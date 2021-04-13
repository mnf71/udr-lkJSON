{
 *	PROGRAM:	UDR samples.
 *	MODULE:		FbMessageMetadata.pas
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

unit FbMessageMetadata;

{$IFDEF MSWINDOWS}
{$DEFINE WINDOWS}
{$ENDIF}
{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses Firebird,
  FbTypes,
{$IFDEF WINDOWS} windows, {$ENDIF}
  Classes,
  SysUtils,
  SysConst,
  System.Generics.Collections;

const
  MAX_IDENTIFIER_LENGTH = 31; // для 4.0 = 63 * 4 -1

type

  // Элемент метаданных
  TFbMessageMetadataItem = class
  private
    FIndex: Cardinal;
    FSQLType: Cardinal;
    FSQLSubType: Integer;
    FDataLength: Cardinal;
    FNullable: Boolean;
    FScale: Integer;
    FCharSetID: Cardinal;
    FRelationName: AnsiString;
    FFieldName: AnsiString;
    FOwnerName: AnsiString;
    FAliasName: AnsiString;
    FOffset: Cardinal;
    FNullOffset: Cardinal;
    FEncoding: TEncoding;
    function GetCharSetName: AnsiString;
    function GetCharSetWidth: Word;
    function GetCodePage: Integer;
    function GetMaxCharLength: Integer;
    function GetEncoding: TEncoding;
    function GetSQLTypeAsString: string;
  public
    constructor Create;
    // -- data
    function GetDataPtr(ABuffer: PByte): PByte;
    // -- null
    function GetNullPtr(ABuffer: PByte): PWordBool;
    function IsNull(ABuffer: PByte): Boolean;
    procedure SetNull(ABuffer: PByte; ANullFlag: Boolean);
    // ---------------
    property SQLType: Cardinal read FSQLType;
    property SQLSubType: Integer read FSQLSubType;
    property DataLength: Cardinal read FDataLength;
    property Nullable: Boolean read FNullable;
    property Scale: Integer read FScale;
    property CharsetID: Cardinal read FCharSetID;
    property RelationName: AnsiString read FRelationName;
    property FieldName: AnsiString read FFieldName;
    property OwnerName: AnsiString read FOwnerName;
    property AliasName: AnsiString read FAliasName;
    property Offset: Cardinal read FOffset;
    property NullOffset: Cardinal read FNullOffset;
    property Index: Cardinal read FIndex;
    // ---------------
    property CharSetName: AnsiString read GetCharSetName;
    property CharSetWidth: Word read GetCharSetWidth;
    property CodePage: Integer read GetCodePage;
    property Encoding: TEncoding read GetEncoding;
    property MaxCharLength: Integer read GetMaxCharLength;
    property SQLTypeAsString: string read GetSQLTypeAsString;
  end;

  // Метаданные
  TFbMessageMetadata = class(TObjectList<TFbMessageMetadataItem>)
  private
    FMessageLength: Cardinal;
  public
    procedure Fill(AStatus: IStatus; AMetaData: IMessageMetadata);
    property MessageLength: Cardinal read FMessageLength;
  end;

implementation

uses FbCharsets;

{ TFbMessageMetadataItem }

constructor TFbMessageMetadataItem.Create;
begin
  SetLength(FRelationName, MAX_IDENTIFIER_LENGTH);
  SetLength(FFieldName, MAX_IDENTIFIER_LENGTH);
  SetLength(FOwnerName, MAX_IDENTIFIER_LENGTH);
  SetLength(FAliasName, MAX_IDENTIFIER_LENGTH);
end;

function TFbMessageMetadataItem.GetCharSetName: AnsiString;
begin
  Result := TFBCharSet(FCharSetID).GetCharSetName();
end;

function TFbMessageMetadataItem.GetCharSetWidth: Word;
begin
  Result := TFBCharSet(FCharSetID).GetCharWidth;
end;

function TFbMessageMetadataItem.GetCodePage: Integer;
begin
  Result := TFBCharSet(FCharSetID).GetCodePage;
end;

function TFbMessageMetadataItem.GetDataPtr(ABuffer: PByte): PByte;
begin
  Result := ABuffer + FOffset;
end;

function TFbMessageMetadataItem.GetEncoding: TEncoding;
begin
  if not Assigned(FEncoding) then
    FEncoding := TEncoding.GetEncoding(CodePage);
  Result := FEncoding;
end;

function TFbMessageMetadataItem.GetMaxCharLength: Integer;
begin
  case TFBType(FSQLSubType) of
    SQL_VARYING, SQL_TEXT:
      Result := FDataLength div CharSetWidth;
    SQL_BLOB, SQL_QUAD:
      Result := High(Integer);
  else
    Result := 0;
  end;
end;

function TFbMessageMetadataItem.GetNullPtr(ABuffer: PByte): PWordBool;
begin
  Result := PWordBool(ABuffer + FNullOffset);
end;

function TFbMessageMetadataItem.GetSQLTypeAsString: string;
begin
  case TFBType(FSQLType) of
    SQL_BOOLEAN:
      begin
        Result := 'BOOLEAN';
      end;

    SQL_SHORT:
      begin
        // учесть масштаб
        Result := 'SMALLINT';
      end;

    SQL_LONG:
      begin
        // учесть масштаб
        Result := 'INTEGER';
      end;

    SQL_INT64:
      begin
        // в 3-м диалекте учитывается масштаб
        if Scale = 0 then
          Result := 'BIGINT'
        else
          Result := 'NUMERIC(18, ' + Abs(Scale).ToString() + ')';
      end;

    SQL_FLOAT:
      begin
        Result := 'FLOAT';
      end;

    SQL_DOUBLE, SQL_D_FLOAT:
      begin
        // в 1-м диалекте учитывается масштаб
        if Scale = 0 then
          Result := 'DOUBLE PRECISION'
        else
          Result := 'NUMERIC(15, ' + Abs(Scale).ToString() + ')';
      end;

    SQL_DATE:
      Result := 'DATE';

    SQL_TIME:
      Result := 'TIME';

    SQL_TIMESTAMP:
      Result := 'TIMESTAMP';

    SQL_TEXT:
      begin
        Result := 'CHAR(' + MaxCharLength.ToString() + ')';
        if CharsetID <> 0 then
          Result := Result + ' CHARACTER SET ' + GetCharSetName();
      end;

    SQL_VARYING:
      begin
        Result := 'VARCHAR(' + MaxCharLength.ToString() + ')';
        if CharsetID <> 0 then
          Result := Result + ' CHARACTER SET ' + GetCharSetName();
      end;

    SQL_BLOB, SQL_QUAD:
      begin
        Result := 'BLOB';
        case SQLSubType of
          0:
            Result := Result + ' SUB_TYPE BINARY';
          1:
            begin
              Result := Result + ' SUB_TYPE TEXT';
              if CharsetID <> 0 then
                Result := Result + ' CHARACTER SET ' + GetCharSetName();
            end
        else
          Result := Result + ' SUB_TYPE ' + SQLSubType.ToString();
        end;
      end;
  end;
end;

function TFbMessageMetadataItem.IsNull(ABuffer: PByte): Boolean;
begin
  Result := GetNullPtr(ABuffer)^;
end;

procedure TFbMessageMetadataItem.SetNull(ABuffer: PByte; ANullFlag: Boolean);
begin
  GetNullPtr(ABuffer)^ := ANullFlag;
end;

{ TFbMessageMetadata }

procedure TFbMessageMetadata.Fill(AStatus: IStatus;
  AMetaData: IMessageMetadata);
var
  xCount: Cardinal;
  i: Cardinal;
  xItem: TFbMessageMetadataItem;
begin
  xCount := AMetaData.getCount(AStatus);
  FMessageLength := AMetaData.getMessageLength(AStatus);
  for i := 0 to xCount - 1 do
  begin
    xItem := TFbMessageMetadataItem.Create;
    xItem.FIndex := i;
    xItem.FRelationName := AMetaData.getRelation(AStatus, i);
    xItem.FFieldName := AMetaData.getField(AStatus, i);
    xItem.FOwnerName := AMetaData.getOwner(AStatus, i);
    xItem.FAliasName := AMetaData.getAlias(AStatus, i);
    xItem.FSQLType := AMetaData.getType(AStatus, i);
    xItem.FNullable := AMetaData.isNullable(AStatus, i);
    xItem.FSQLSubType := AMetaData.getSubType(AStatus, i);
    xItem.FDataLength := AMetaData.getLength(AStatus, i);
    xItem.FScale := AMetaData.getScale(AStatus, i);
    xItem.FCharSetID := AMetaData.getCharSet(AStatus, i);
    xItem.FOffset := AMetaData.getOffset(AStatus, i);
    xItem.FNullOffset := AMetaData.getNullOffset(AStatus, i);
    Add(xItem);
  end;
end;

end.
