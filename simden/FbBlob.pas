{
 *	PROGRAM:	UDR samples.
 *	MODULE:		FbBlob.pas
 *	DESCRIPTION:	Blob helpers.
 *
 *  The contents of this file are subject to the Initial
 *  Developer's Public License Version 1.0 (the "License");
 *  you may not use this file except in compliance with the
 *  License. You may obtain a copy of the License at
 *  http://www.ibphoenix.com/main.nfs?a=ibphoenix&page=ibp_idpl.
 *
 *  Software distributed under the License is distributed AS IS,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied.
 *  See the License for the specific language governing rights
 *  and limitations under the License.
 *
 *  The Original Code was created by Simonov Denis
 *  for the book Writing UDR Firebird in Pascal.
 *
 *  Copyright (c) 2018 Simonov Denis <sim-mail@list.ru>
 *  and all contributors signed below.
 *
 *  All Rights Reserved.
 *  Contributor(s): ______________________________________. }

unit FbBlob;

interface

uses Classes, SysUtils, Firebird;

const
  MAX_SEGMENT_SIZE = $7FFF;

type
  TBlobType = (btSegmented, btStream);

  TFbBlobInfo = record
    NumSegments: Integer;
    MaxSegmentSize: Integer;
    TotalLength: Integer;
    BlobType: Smallint;
  end;

  TFbBlobHelper = class helper for IBlob
    function Read(AStatus: IStatus; var Buffer; Count: Cardinal): Cardinal;
    function Write(AStatus: IStatus; const Buffer; Count: Cardinal): Cardinal;
    procedure GetBlobInfo(AStatus: IStatus; var NumSegments, MaxSegmentSize,
      TotalSize: Longint; var BlobType: Smallint);
    { Загружает в BLOB содержимое потока

      @param(AStatus Статус вектор)
      @param(AStream Поток)
    }
    procedure LoadFromStream(AStatus: IStatus; AStream: TStream);
    { Загружает в поток содержимое BLOB

      @param(AStatus Статус вектор)
      @param(AStream Поток)
    }
    procedure SaveToStream(AStatus: IStatus; AStream: TStream);
  end;

implementation

uses Math;

const
  (* ************************ *)
  (* Blob information items *)
  (* ************************ *)
  isc_info_end = 1;
  isc_info_truncated = 2;
  isc_info_error = 3;
  isc_info_blob_num_segments = 4;
  isc_info_blob_max_segment = 5;
  isc_info_blob_total_length = 6;
  isc_info_blob_type = 7;

function isc_portable_integer(const ptr: PByte; length: Smallint): Int64;
var
  value: Int64;
  shift: Smallint;
  i: Smallint;
begin
  if ((not Assigned(ptr)) or (length <= 0) or (length > 8)) then
  begin
    Result := 0;
    Exit;
  end;

  value := 0;
  shift := 0;
  i := 0;
  while length > 0 do
  begin
    value := value + (Int64((ptr + i)^) shl shift);
    Dec(length);
    Inc(shift, 8);
    Inc(i);
  end;

  Result := value;
end;

{ TFbBlobHelper }

procedure TFbBlobHelper.GetBlobInfo(AStatus: IStatus;
  var NumSegments, MaxSegmentSize, TotalSize: Integer; var BlobType: Smallint);
var
  items: array [0 .. 3] of Byte;
  results: array [0 .. 99] of Byte;
  i, item_length: Integer;
  item: Integer;
begin
  items[0] := Byte(isc_info_blob_num_segments);
  items[1] := Byte(isc_info_blob_max_segment);
  items[2] := Byte(isc_info_blob_total_length);
  items[3] := Byte(isc_info_blob_type);

  Self.getInfo(AStatus, 4, @items[0], Sizeof(results), @results);

  i := 0;
  while (i < Sizeof(results)) and (results[i] <> Byte(isc_info_end)) do
  begin
    item := Integer(results[i]);
    Inc(i);
    item_length := isc_portable_integer(@results[i], 2);
    Inc(i, 2);
    case item of
      isc_info_blob_num_segments:
        NumSegments := isc_portable_integer(@results[i], item_length);
      isc_info_blob_max_segment:
        MaxSegmentSize := isc_portable_integer(@results[i], item_length);
      isc_info_blob_total_length:
        TotalSize := isc_portable_integer(@results[i], item_length);
      isc_info_blob_type:
        BlobType := isc_portable_integer(@results[i], item_length);
    end;
    Inc(i, item_length);
  end;

end;

procedure TFbBlobHelper.LoadFromStream(AStatus: IStatus; AStream: TStream);
var
  xStreamSize: Integer;
  xReadLength: Integer;
  xBuffer: array [0 .. MAX_SEGMENT_SIZE] of Byte;
begin
  xStreamSize := AStream.Size;
  AStream.Position := 0;
  while xStreamSize <> 0 do
  begin
    xReadLength := Min(xStreamSize, MAX_SEGMENT_SIZE);
    AStream.ReadBuffer(xBuffer, xReadLength);
    Self.putSegment(AStatus, xReadLength, @xBuffer[0]);
    Dec(xStreamSize, xReadLength);
  end;
end;

function TFbBlobHelper.Read(AStatus: IStatus; var Buffer;
  Count: Cardinal): Cardinal;
var
  xLocalLength: Cardinal;
  xLocalBuffer: PByte;
  xBytesRead: Cardinal;
  xRetutnCode: Integer;
begin
  Result := 0;

  xLocalBuffer := PByte(@Buffer);
  repeat
    xLocalLength := Min(Count, MAX_SEGMENT_SIZE);
    xRetutnCode := Self.getSegment(AStatus, xLocalLength, xLocalBuffer,
      @xBytesRead);
    Inc(xLocalBuffer, xBytesRead);
    Inc(Result, xBytesRead);
    Dec(Count, xBytesRead);
  until ((xRetutnCode <> IStatus.RESULT_OK) and
    (xRetutnCode <> IStatus.RESULT_SEGMENT)) or (Count = 0);
end;

procedure TFbBlobHelper.SaveToStream(AStatus: IStatus; AStream: TStream);
var
  Buffer: array [0 .. MAX_SEGMENT_SIZE] of Byte;
  xBytesRead: Cardinal;
  xBufferSize: Cardinal;
begin
  AStream.Position := 0;
  xBufferSize := Min(SizeOf(Buffer), MAX_SEGMENT_SIZE);
  while True do
  begin
    case Self.getSegment(AStatus, xBufferSize, @Buffer[0], @xBytesRead) of
      IStatus.RESULT_OK:
        AStream.WriteBuffer(Buffer, xBytesRead);
      IStatus.RESULT_SEGMENT:
        AStream.WriteBuffer(Buffer, xBytesRead);
    else
      break;
    end;
  end;
end;

function TFbBlobHelper.Write(AStatus: IStatus; const Buffer;
  Count: Cardinal): Cardinal;
var
  xLocalBuffer: PByte;
  xLocalLength: Cardinal;
begin
  Result := 0;
  if Count = 0 then
    Exit;

  xLocalBuffer := PByte(@Buffer);
  repeat
    xLocalLength := Min(Count, MAX_SEGMENT_SIZE);
    Self.putSegment(AStatus, xLocalLength, xLocalBuffer);
    Inc(xLocalBuffer, xLocalLength);
    Inc(Result, xLocalLength);
    Dec(Count, xLocalLength);
  until Count <= 0;
end;

end.
