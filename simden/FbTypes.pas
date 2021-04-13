{
 *	PROGRAM:	UDR samples.
 *	MODULE:		FbTypes.pas
 *	DESCRIPTION:	Missing types in Firebird.pas
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
 
unit FbTypes;

{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Firebird;


const
  // типы Firebird
  SQL_VARYING = 448; // VARCHAR
  SQL_TEXT = 452; // CHAR
  SQL_DOUBLE = 480; // DOUBLE PRECISION
  SQL_FLOAT = 482; // FLOAT
  SQL_LONG = 496; // INTEGER
  SQL_SHORT = 500; // SMALLINT
  SQL_TIMESTAMP = 510; // TIMESTAMP
  SQL_BLOB = 520; // BLOB
  SQL_D_FLOAT = 530; // DOUBLE PRECISION
  SQL_ARRAY = 540; // ARRAY
  SQL_QUAD = 550; // BLOB_ID (QUAD)
  SQL_TIME = 560; // TIME
  SQL_DATE = 570; // DATE
  SQL_INT64 = 580; // BIGINT
  SQL_BOOLEAN = 32764; // BOOLEAN
  SQL_NULL = 32766; // NULL

type
  // TIMESTAMP
  ISC_TIMESTAMP = record
    date: ISC_DATE;
    time: ISC_TIME;
  end;

  // указатели на специальные типы
  PISC_DATE = ^ISC_DATE;
  PISC_TIME = ^ISC_TIME;
  PISC_TIMESTAMP = ^ISC_TIMESTAMP;
  PISC_QUAD = ^ISC_QUAD;

  TVarChar<T> = record
    Length: Smallint;
    value: T
  end;

implementation

end.
