{
 *	PROGRAM:	UDR samples.
 *	MODULE:		FbMessageData.pas
 *	DESCRIPTION:	Metadata utils.
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

unit FbMessageData;

{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  SysUtils,
  SysConst,
  Classes,
  Firebird,
  FbTypes,
  FbMessageMetadata;

type

  TFbMessageData = class
  private
    FContext: IExternalContext;
    FMetadata: TFbMessageMetadata;
    FBuffer: PByte;
    function GetFbUtil: IUtil;
    function IscDateToDate(AValue: ISC_DATE): TDate;
    function IscTimeToTime(AValue: ISC_TIME): TTime;
    function IscTimestampToDateTime(AValue: ISC_TIMESTAMP): TDateTime;
    function IscTimestampToTimestamp(AValue: ISC_TIMESTAMP): TTimestamp;
    function DateToIscDate(AValue: TDate): ISC_DATE;
    function TimeToIscTime(AValue: TTime): ISC_TIME;
    function DateTimeToIscTimestamp(AValue: TDateTime): ISC_TIMESTAMP;
    function TimestampToIscTimestamp(AValue: TTimestamp): ISC_TIMESTAMP;
  public
    constructor Create(AContext: IExternalContext;
      AMetaData: TFbMessageMetadata; ABuffer: PByte);
    // возвращает указатель на данные
    function GetData(AIndex: Cardinal): PByte;
    // null
    function isNull(AIndex: Cardinal): Boolean;
    procedure setNull(AIndex: Cardinal; ANullFlag: Boolean);
    // простые типы
    function getBoolean(AIndex: Cardinal): Boolean;
    procedure setBoolean(AIndex: Cardinal; AValue: Boolean);
    function getSmallint(AIndex: Cardinal): Smallint;
    procedure setSmallint(AIndex: Cardinal; AValue: Smallint);
    function getInteger(AIndex: Cardinal): Integer;
    procedure setInteger(AIndex: Cardinal; AValue: Integer);
    function getBigint(AIndex: Cardinal): Int64;
    procedure setBigint(AIndex: Cardinal; AValue: Int64);
    function getFloat(AIndex: Cardinal): Single;
    procedure setFloat(AIndex: Cardinal; AValue: Single);
    function getDouble(AIndex: Cardinal): Double;
    procedure setDouble(AIndex: Cardinal; AValue: Double);
    function getIscDate(AIndex: Cardinal): ISC_DATE;
    procedure setIscDate(AIndex: Cardinal; AValue: ISC_DATE);
    function getIscTime(AIndex: Cardinal): ISC_TIME;
    procedure setIscTime(AIndex: Cardinal; AValue: ISC_TIME);
    function getIscTimestamp(AIndex: Cardinal): ISC_TIMESTAMP;
    procedure setIscTimestamp(AIndex: Cardinal; AValue: ISC_TIMESTAMP);
    function getDate(AIndex: Cardinal): TDate;
    procedure setDate(AIndex: Cardinal; AValue: TDate);
    function getTime(AIndex: Cardinal): TTime;
    procedure setTime(AIndex: Cardinal; AValue: TTime);
    function getTimestamp(AIndex: Cardinal): TTimestamp;
    procedure setTimestamp(AIndex: Cardinal; AValue: TTimestamp);
    function getDateTime(AIndex: Cardinal): TDateTime;
    procedure setDateTime(AIndex: Cardinal; AValue: TDateTime);
    function getString(AIndex: Cardinal): string;
    procedure setString(AIndex: Cardinal; const AValue: string);
    // свойства
    property Metadata: TFbMessageMetadata read FMetadata;
    property FbUtil: IUtil read GetFbUtil;
    // null
    property Null[AIndex: Cardinal]: Boolean read isNull write setNull;
    // типы
    property AsBoolean[AIndex: Cardinal]: Boolean read getBoolean
      write setBoolean;
    property AsSmallint[AIndex: Cardinal]: Smallint read getSmallint
      write setSmallint;
    property AsInteger[AIndex: Cardinal]: Integer read getInteger
      write setInteger;
    property AsBigint[AIndex: Cardinal]: Int64 read getBigint write setBigint;
    property AsFloat[AIndex: Cardinal]: Single read getFloat write setFloat;
    property AsDouble[AIndex: Cardinal]: Double read getDouble write setDouble;
    property AsIscDate[AIndex: Cardinal]: ISC_DATE read getIscDate
      write setIscDate;
    property AsIscTime[AIndex: Cardinal]: ISC_TIME read getIscTime
      write setIscTime;
    property AsIscTimestamp[AIndex: Cardinal]: ISC_TIMESTAMP
      read getIscTimestamp write setIscTimestamp;
    property AsDate[AIndex: Cardinal]: TDate read getDate write setDate;
    property AsTime[AIndex: Cardinal]: TTime read getTime write setTime;
    property AsTimestamp[AIndex: Cardinal]: TTimestamp read getTimestamp
      write setTimestamp;
    property AsDateTime[AIndex: Cardinal]: TDateTime read getDateTime
      write setDateTime;
    property AsString[AIndex: Cardinal]: string read getString write setString;
  end;

implementation

uses DateUtils;

{ TFbMessageData }

constructor TFbMessageData.Create(AContext: IExternalContext;
  AMetaData: TFbMessageMetadata; ABuffer: PByte);
begin
  FContext := AContext;
  FMetadata := AMetaData;
  FBuffer := ABuffer;
end;

function TFbMessageData.DateTimeToIscTimestamp(
  AValue: TDateTime): ISC_TIMESTAMP;
var
  xYear: Word;
  xMonth: Word;
  xDay: Word;
  xHour: Word;
  xMinute: Word;
  xSecond: Word;
  xMS: Word;
begin
  DecodeDateTime(AValue, xYear, xMonth, xDay, xHour, xMinute, xSecond, xMS);
  Result.date := FbUtil.EncodeDate(xYear, xMonth, xDay);
  Result.time := FbUtil.EncodeTime(xHour, xMinute, xSecond, xMS * 10);
end;

function TFbMessageData.DateToIscDate(AValue: TDate): ISC_DATE;
var
  xYear: Word;
  xMonth: Word;
  xDay: Word;
begin
  DecodeDate(TDateTime(AValue), xYear, xMonth, xDay);
  Result := FbUtil.EncodeDate(xYear, xMonth, xDay);
end;

function TFbMessageData.getBigint(AIndex: Cardinal): Int64;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      Result := getSmallint(AIndex);

    SQL_LONG:
      Result := getInteger(AIndex);

    SQL_INT64:
      Result := PInt64(GetData(AIndex))^;

    SQL_TEXT, SQL_VARYING:
      Result := Int64.Parse(getString(AIndex));

  else
    raise Exception.CreateFmt('Can not convert %s to BIGINT',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getBoolean(AIndex: Cardinal): Boolean;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_BOOLEAN:
      Result := PBoolean(GetData(AIndex))^;

    SQL_TEXT, SQL_VARYING:
      Result := Boolean.Parse(getString(AIndex));
  else
    raise Exception.CreateFmt('Can not convert %s to BOOLEAN',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.GetData(AIndex: Cardinal): PByte;
begin
  Result := FBuffer + FMetadata[AIndex].Offset;
end;

function TFbMessageData.getDate(AIndex: Cardinal): TDate;
begin
  Result := IscDateToDate(getIscDate(AIndex));
end;

function TFbMessageData.getDateTime(AIndex: Cardinal): TDateTime;
begin
  Result := IscTimestampToDateTime(getIscTimestamp(AIndex));
end;

function TFbMessageData.getDouble(AIndex: Cardinal): Double;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      Result := getSmallint(AIndex);

    SQL_LONG:
      Result := getInteger(AIndex);

    SQL_INT64:
      Result := getBigint(AIndex);

    SQL_FLOAT:
      Result := getFloat(AIndex);

    SQL_DOUBLE:
      Result := PDouble(GetData(AIndex))^;

    SQL_TEXT, SQL_VARYING:
      Result := Single.Parse(getString(AIndex));

  else
    raise Exception.CreateFmt('Can not convert %s to DOUBLE PRECISION',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.GetFbUtil: IUtil;
begin
  Result := FContext.getMaster().getUtilInterface();
end;

function TFbMessageData.getFloat(AIndex: Cardinal): Single;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      Result := getSmallint(AIndex);

    SQL_LONG:
      Result := getInteger(AIndex);

    SQL_INT64:
      Result := getBigint(AIndex);

    SQL_FLOAT:
      Result := PSingle(GetData(AIndex))^;

    SQL_DOUBLE:
      Result := getDouble(AIndex);

    SQL_TEXT, SQL_VARYING:
      Result := Single.Parse(getString(AIndex));

  else
    raise Exception.CreateFmt('Can not convert %s to FLOAT',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getInteger(AIndex: Cardinal): Integer;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      Result := getSmallint(AIndex);

    SQL_LONG:
      Result := PInteger(GetData(AIndex))^;

    SQL_INT64:
      Result := getBigint(AIndex);

    SQL_TEXT, SQL_VARYING:
      Result := Integer.Parse(getString(AIndex));

  else
    raise Exception.CreateFmt('Can not convert %s to INTEGER',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getIscDate(AIndex: Cardinal): ISC_DATE;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_DATE:
      Result := PISC_DATE(GetData(AIndex))^;

    SQL_TIMESTAMP:
      Result := getIscTimestamp(AIndex).date;

  else
    raise Exception.CreateFmt('Can not convert %s to DATE',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getIscTime(AIndex: Cardinal): ISC_TIME;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_TIME:
      Result := PISC_TIME(GetData(AIndex))^;

    SQL_TIMESTAMP:
      Result := getIscTimestamp(AIndex).time;
  else
    raise Exception.CreateFmt('Can not convert %s to TIME',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getIscTimestamp(AIndex: Cardinal): ISC_TIMESTAMP;
var
  xTime: ISC_TIME;
  xDate: ISC_DATE;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_TIME:
      begin
        xTime := PISC_TIME(GetData(AIndex))^;
        Result.date := DateToIscDate(Date());
        Result.time := xTime;
      end;

    SQL_DATE:
      begin
        xDate := PISC_DATE(GetData(AIndex))^;
        Result.date := xDate;
        Result.time := 0;
      end;

    SQL_TIMESTAMP:
      Result := PISC_TIMESTAMP(GetData(AIndex))^;
  else
    raise Exception.CreateFmt('Can not convert %s to DATE',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getSmallint(AIndex: Cardinal): Smallint;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      Result := PSmallint(GetData(AIndex))^;

    SQL_LONG:
      Result := getInteger(AIndex);

    SQL_INT64:
      Result := getBigint(AIndex);

    SQL_TEXT, SQL_VARYING:
      Result := Smallint.Parse(getString(AIndex));

  else
    raise Exception.CreateFmt('Can not convert %s to SMALLINT',
      [FMetadata[AIndex].SQLTypeAsString]);
  end;
end;

function TFbMessageData.getString(AIndex: Cardinal): string;
var
  xMetadataItem: TFbMessageMetadataItem;
  xCharLength: Smallint;
begin
  xMetadataItem := FMetadata[AIndex];
  case TFBType(xMetadataItem.SQLType) of
    SQL_BOOLEAN:
      Result := getBoolean(AIndex).ToString();

    SQL_SHORT:
      Result := getSmallint(AIndex).ToString();

    SQL_LONG:
      Result := getInteger(AIndex).ToString();

    SQL_INT64:
      Result := getBigint(AIndex).ToString();

    SQL_FLOAT:
      Result := getFloat(AIndex).ToString();

    SQL_DOUBLE:
      Result := getDouble(AIndex).ToString();

    SQL_DATE:
      Result := DateToStr(getDate(AIndex));

    SQL_TIME:
      Result := TimeToStr(getTime(AIndex));

    SQL_TIMESTAMP:
      Result := DateToStr(getDateTime(AIndex));

    SQL_VARYING:
      begin
        xCharLength := PSmallint(FBuffer + xMetadataItem.Offset)^;
        Result := xMetadataItem.Encoding.getString(TBytes(@FBuffer),
          2 + xMetadataItem.Offset, xMetadataItem.DataLength);
        SetLength(Result, xCharLength);
      end;

    SQL_TEXT:
      begin
        Result := xMetadataItem.Encoding.getString(TBytes(@FBuffer),
          xMetadataItem.Offset, xMetadataItem.DataLength);
        SetLength(Result, xMetadataItem.DataLength);
      end;
  end;
end;

function TFbMessageData.getTime(AIndex: Cardinal): TTime;
begin
  Result := IscTimeToTime(getIscTime(AIndex));
end;

function TFbMessageData.getTimestamp(AIndex: Cardinal): TTimestamp;
begin
  Result := IscTimestampToTimestamp(getIscTimestamp(AIndex));
end;

function TFbMessageData.IscDateToDate(AValue: ISC_DATE): TDate;
var
  xYear: Cardinal;
  xMonth: Cardinal;
  xDay: Cardinal;
begin
  FbUtil.decodeDate(AValue, @xYear, @xMonth, @xDay);
  Result := EncodeDate(xYear, xMonth, xDay);
end;

function TFbMessageData.IscTimestampToDateTime(
  AValue: ISC_TIMESTAMP): TDateTime;
var
  xYear: Cardinal;
  xMonth: Cardinal;
  xDay: Cardinal;
  xHour: Cardinal;
  xMinutes: Cardinal;
  xSeconds: Cardinal;
  xFractions: Cardinal;
begin
  FbUtil.decodeDate(AValue.date, @xYear, @xMonth, @xDay);
  FbUtil.decodeTime(AValue.time, @xHour, @xMinutes, @xSeconds,
    @xFractions);
  Result := EncodeDateTime(xYear, xMonth, xDay, xHour, xMinutes, xSeconds,
    xFractions div 10);
end;

function TFbMessageData.IscTimestampToTimestamp(
  AValue: ISC_TIMESTAMP): TTimestamp;
begin
  Result.date := AValue.date;
  Result.time := AValue.time div 10;
end;

function TFbMessageData.IscTimeToTime(AValue: ISC_TIME): TTime;
var
  xHour: Cardinal;
  xMinutes: Cardinal;
  xSeconds: Cardinal;
  xFractions: Cardinal;
begin
  FbUtil.decodeTime(AValue, @xHour, @xMinutes, @xSeconds, @xFractions);
  Result := EncodeTime(xHour, xMinutes, xSeconds, xFractions div 10);
end;

function TFbMessageData.isNull(AIndex: Cardinal): Boolean;
begin
  Result := not FMetadata[AIndex].Nullable or
    PWordBool(FBuffer + FMetadata[AIndex].NullOffset)^;
end;

procedure TFbMessageData.setBigint(AIndex: Cardinal; AValue: Int64);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      setSmallint(AIndex, AValue);

    SQL_LONG:
      setInteger(AIndex, AValue);

    SQL_INT64:
      begin
        setNull(AIndex, False);
        PInt64(GetData(AIndex))^ := AValue;
      end;

    SQL_FLOAT:
      setFloat(AIndex, AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AIndex, AValue);

    SQL_TEXT, SQL_VARYING:
        setString(AIndex, AValue.ToString())

  else
    begin
      raise Exception.Create('Can not convert BIGINT value to ' +
        FMetadata[AIndex].SQLTypeAsString);
    end;
  end;
end;

procedure TFbMessageData.setBoolean(AIndex: Cardinal; AValue: Boolean);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_BOOLEAN:
      begin
        setNull(AIndex, False);
        PBoolean(GetData(AIndex))^ := AValue;
      end;

    SQL_TEXT, SQL_VARYING:
      begin
        if AValue then
          setString(AIndex, 'True')
        else
          setString(AIndex, 'False');
      end;

  else
    begin
      raise Exception.CreateFmt('Can not convert BOOLEAN to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setDate(AIndex: Cardinal; AValue: TDate);
begin
  setIscDate(AIndex, DateToIscDate(AValue));
end;

procedure TFbMessageData.setDateTime(AIndex: Cardinal; AValue: TDateTime);
begin
  setIscTimestamp(AIndex, DateTimeToIscTimestamp(AValue));
end;

procedure TFbMessageData.setDouble(AIndex: Cardinal; AValue: Double);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_DOUBLE, SQL_D_FLOAT:
      begin
        setNull(AIndex, False);
        PDouble(GetData(AIndex))^ := AValue;
      end;

    SQL_TEXT, SQL_VARYING:
      setString(AIndex, AValue.ToString());

  else
    begin
      raise Exception.CreateFmt('Can not convert DOUBLE PRECISION to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setFloat(AIndex: Cardinal; AValue: Single);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_FLOAT:
      begin
        setNull(AIndex, False);
        PSingle(GetData(AIndex))^ := AValue;
      end;

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AIndex, AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AIndex, AValue.ToString())

  else
    begin
      raise Exception.CreateFmt('Can not convert FLOAT to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setInteger(AIndex: Cardinal; AValue: Integer);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      setSmallint(AIndex, AValue);

    SQL_LONG:
      begin
        setNull(AIndex, False);
        PInteger(GetData(AIndex))^ := AValue;
      end;

    SQL_INT64:
      setBigint(AIndex, AValue);

    SQL_FLOAT:
      setFloat(AIndex, AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AIndex, AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AIndex, AValue.ToString())

  else
    begin
      raise Exception.CreateFmt('Can not convert INTEGER to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setIscDate(AIndex: Cardinal; AValue: ISC_DATE);
var
  xTimestamp: ISC_TIMESTAMP;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_DATE:
      begin
        setNull(AIndex, False);
        PISC_DATE(GetData(AIndex))^ := AValue;
      end;

    SQL_TIMESTAMP:
      begin
        xTimestamp.date := AValue;
        xTimestamp.time := 0;
        setIscTimestamp(AIndex, xTimestamp);
      end;

  else
    begin
      raise Exception.CreateFmt('Can not convert DATE to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setIscTime(AIndex: Cardinal; AValue: ISC_TIME);
var
  xTimestamp: ISC_TIMESTAMP;
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_TIME:
      begin
        setNull(AIndex, False);
        PISC_TIME(GetData(AIndex))^ := AValue;
      end;

    SQL_TIMESTAMP:
      begin
        xTimestamp.date := DateToIscDate(Date());
        xTimestamp.time := AValue;
        setIscTimestamp(AIndex, xTimestamp);
      end;

  else
    begin
      raise Exception.CreateFmt('Can not convert TIME to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setIscTimestamp(AIndex: Cardinal;
  AValue: ISC_TIMESTAMP);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_TIMESTAMP:
      begin
        setNull(AIndex, False);
        PISC_TIMESTAMP(GetData(AIndex))^ := AValue;
      end;

  else
    begin
      raise Exception.CreateFmt('Can not convert TIMESTAMP to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setNull(AIndex: Cardinal; ANullFlag: Boolean);
begin
  if not FMetadata[AIndex].Nullable then
    raise Exception.CreateFmt('Field %d not nullable', [AIndex]);
  if ANullFlag then
    PSmallint(FBuffer + FMetadata[AIndex].NullOffset)^ := -1
  else
    PSmallint(FBuffer + FMetadata[AIndex].NullOffset)^ := 0;
end;

procedure TFbMessageData.setSmallint(AIndex: Cardinal; AValue: Smallint);
begin
  case TFBType(FMetadata[AIndex].SQLType) of
    SQL_SHORT:
      begin
        setNull(AIndex, False);
        PSmallint(GetData(AIndex))^ := AValue;
      end;

    SQL_LONG:
      setInteger(AIndex, AValue);

    SQL_INT64:
      setBigint(AIndex, AValue);

    SQL_FLOAT:
      setFloat(AIndex, AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AIndex, AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AIndex, AValue.ToString());

  else
    begin
      raise Exception.CreateFmt('Can not convert SMALLINT to %s',
        [FMetadata[AIndex].SQLTypeAsString]);
    end;
  end;
end;

procedure TFbMessageData.setString(AIndex: Cardinal; const AValue: string);
var
  xMetadataItem: TFbMessageMetadataItem;
  xBytes: TBytes;
  xBuffer: PByte;
begin
  setNull(AIndex, False);
  xMetadataItem := FMetadata[AIndex];
  case TFBType(xMetadataItem.SQLType) of
    SQL_BOOLEAN:
      setBoolean(AIndex, AValue.ToBoolean());

    SQL_SHORT:
      setSmallint(AIndex, Smallint.Parse(AValue));

    SQL_LONG:
      setInteger(AIndex, AValue.ToInteger());

    SQL_INT64:
      setInteger(AIndex, Int64.Parse(AValue));

    SQL_FLOAT:
      setFloat(AIndex, AValue.ToSingle());

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AIndex, AValue.ToDouble);

    SQL_TIME:
      setTime(AIndex, StrToTime(AValue));

    SQL_DATE:
      setDate(AIndex, StrToDate(AValue));

    SQL_TIMESTAMP:
      setDateTime(AIndex, StrToDateTime(AValue));

    SQL_VARYING:
      begin
        if (Length(AValue) > xMetadataItem.DataLength) then
          raise Exception.CreateFmt
            ('String trancation, expected char length %d, actual %d',
            [xMetadataItem.DataLength, Length(AValue)]);

        xBytes := xMetadataItem.Encoding.GetBytes(AValue);
        PSmallint(FBuffer + xMetadataItem.Offset)^ := Length(AValue);

        if High(xBytes) > xMetadataItem.DataLength then
          raise Exception.CreateFmt
            ('String trancation, expected byte length %d, actual %d',
            [xMetadataItem.DataLength, High(xBytes)]);

        xBuffer := GetData(AIndex) + 2;
        Move(xBytes, xBuffer, High(xBytes));
      end;

    SQL_TEXT:
      begin
        if (Length(AValue) > xMetadataItem.DataLength) then
          raise Exception.CreateFmt
            ('String trancation, expected length %d, actual %d',
            [xMetadataItem.DataLength, Length(AValue)]);

        xBytes := xMetadataItem.Encoding.GetBytes(AValue);

        if High(xBytes) > xMetadataItem.DataLength then
          raise Exception.CreateFmt
            ('String trancation, expected byte length %d, actual %d',
            [xMetadataItem.DataLength, High(xBytes)]);

        xBuffer := GetData(AIndex);
        Move(xBytes, xBuffer, High(xBytes));
      end;
  end;
end;

procedure TFbMessageData.setTime(AIndex: Cardinal; AValue: TTime);
begin
  setIscTime(AIndex, TimeToIscTime(AValue));
end;

procedure TFbMessageData.setTimestamp(AIndex: Cardinal; AValue: TTimestamp);
begin
  setIscTimestamp(AIndex, TimestampToIscTimestamp(AValue));
end;

function TFbMessageData.TimestampToIscTimestamp(
  AValue: TTimestamp): ISC_TIMESTAMP;
begin
  Result.date := AValue.date;
  Result.time := AValue.time * 10;
end;

function TFbMessageData.TimeToIscTime(AValue: TTime): ISC_TIME;
var
  xHour: Word;
  xMinute: Word;
  xSecond: Word;
  xMS: Word;
begin
  decodeTime(TDateTime(AValue), xHour, xMinute, xSecond, xMS);
  Result := FbUtil.EncodeTime(xHour, xMinute, xSecond, xMS * 10);
end;

end.
