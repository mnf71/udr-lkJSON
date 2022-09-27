{
 *	PROGRAM: lkJSON <liblkjson.so>
 *	MODULE: udrJSON.pas
 *	DESCRIPTION: JSON Routine
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
 *  The Original Code was created by Filatov Maxim.
 *
 *  Copyright (c) 2020 Filatov Maxim <2chemist@mail.ru>
 *  and all contributors signed below.
 *
 *  All Rights Reserved.
 *  Contributor(s): ______________________________________. }

unit udrJSON;

{$IFDEF FPC}
  {$IFDEF GENERIC}
    {$MODE OBJFPC}{$H+}
  {$ELSE}
    {$MODE DELPHI}{$H+}
  {$ENDIF}
{$ELSE}
{$ENDIF}

interface

uses Classes, SysUtils, Variants, Firebird, UdrFactories, uLkJSON;

const
  vcFb = 32765;

type

  TjsPtr = array [0..7] of Byte;

  TjsObj = record
    Ptr: TjsPtr;
    Null: WordBool;
  end;
  PjsObj = ^TjsObj;

  TjsSelf = record
    Self: TjsObj;
  end;
  PjsSelf = ^TjsSelf;

  TjsBool = record
    Val: ByteBool;
    Null: WordBool;
  end;
  PjsBool = ^TjsBool;

  TjsSmallInt = packed record
    Val: SmallInt;
    Null: WordBool;
  end;
  PjsSmallInt = ^TjsSmallInt;

  TjsInteger = packed record
    Val: Integer;
    Null: WordBool;
  end;
  PjsInteger = ^TjsInteger;

  TjsDouble = packed record
    Val: Double;
    Null: WordBool;
  end;
  PjsDouble = ^TjsDouble;

  Tjsvc64 = record
    Len: Word;
    Val: array [0..63] of AnsiChar;
    Null: WordBool;
  end;
  Pjsvc64 = ^Tjsvc64;

  Tjsvc256 = record
    Len: Word;
    Val: array [0..255] of AnsiChar;
    Null: WordBool;
  end;
  Pjsvc256 = ^Tjsvc256;

  TjsvcX = record
    Len: Word;
    Val: array [0..vcFb - 1] of AnsiChar;
    Null: WordBool;
  end;
  PjsvcX = ^TjsvcX;

  TjsWStr = record
    Ptr: ISC_QUAD;
    Null: WordBool;
  end;
  PjsWStr = ^TjsWStr;

  TjsSelfType = record
    SelfType: TjsSmallInt
  end;
  PjsSelfType = ^TjsSelfType;

  TjsSelfTypeName = record
    SelfTypeName: Tjsvc64;
  end;
  PjsSelfTypeName = ^TjsSelfTypeName;

  TjsFunction = class(TExternalFunction)
    procedure dispose(); override;
    procedure getCharSet
      (AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar;
       ANameSize: Cardinal);
      override;
  end;

{$IFNDEF GENERIC}
  TjsFunctionFactory<_T: TjsFunction, constructor> = class(TFunctionFactory<_T>)
{$ELSE}
  generic TjsFunctionFactory<_T: TjsFunction> = class(specialize TFunctionFactory<_T>)
{$ENDIF}
    procedure dispose(); override;
    function newItem
      (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata):
      IExternalFunction;
      override;
    procedure setup
      (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
       AInBuilder: IMetadataBuilder; AOutBuilder: IMetadataBuilder);
      override;
  end;

  TjsProcedure = class(TExternalProcedure)
    procedure dispose(); override;
    procedure getCharSet
      (AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
      override;
  end;

{$IFNDEF GENERIC}
  TjsProcedureFactory<_T: TjsProcedure, constructor> = class(TProcedureFactory<_T>)
{$ELSE}
  generic TjsProcedureFactory<_T: TjsProcedure> = class(specialize TProcedureFactory<_T>)
{$ENDIF}
    procedure dispose(); override;
    function newItem
      (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata):
      IExternalProcedure;
      override;
    procedure setup
      (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
       AInBuilder: IMetadataBuilder; AOutBuilder: IMetadataBuilder);
      override;
  end;

{ TlkJSONObject }

  TjsInObjectNew = record
    UseHash: TjsBool;
  end;
  PjsInObjectNew = ^TjsInObjectNew;

  TjsOutObjectNew = record
    Self: TjsObj;
  end;
  PjsOutObjectNew = ^TjsOutObjectNew;

  TjsObjectNew = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectDispose = record
    Self: TjsObj;
  end;
  PjsInObjectDispose = ^TjsInObjectDispose;

  TjsOutObjectDispose = record
    Res: TjsSmallInt;
  end;
  PjsOutObjectDispose = ^TjsOutObjectDispose;

  TjsObjectDispose = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectField = record
    Self: TjsObj;
    Name: Tjsvc256;
    Obj: TjsObj;
  end;
  PjsInObjectField = ^TjsInObjectField;

  TjsOutObjectField = record
    Obj: TjsObj;
  end;
  PjsOutObjectField = ^TjsOutObjectField;

  TjsObjectField = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectFieldByIndex = record
    Self: TjsObj;
    Idx: TjsInteger;
    Obj: TjsObj;
  end;
  PjsInObjectFieldByIndex = ^TjsInObjectFieldByIndex;

  TjsOutObjectFieldByIndex = record
    Obj: TjsObj;
  end;
  PjsOutObjectFieldByIndex = ^TjsOutObjectFieldByIndex;

  TjsObjectFieldByIndex = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectNameOf = record
    Self: TjsObj;
    Idx: TjsInteger;
  end;
  PjsInObjectNameOf = ^TjsInObjectNameOf;

  TjsOutObjectNameOf = record
    Name: Tjsvc256;
  end;
  PjsOutObjectNameOf = ^TjsOutObjectNameOf;

  TjsObjectNameOf = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectIndexOfName = record
    Self: TjsObj;
    Name: Tjsvc256;
  end;
  PjsInObjectIndexOfName = ^TjsInObjectIndexOfName;

  TjsOutObjectIndexOfName = record
    Idx: TjsInteger;
  end;
  PjsOutObjectIndexOfName = ^TjsOutObjectIndexOfName;

  TjsObjectIndexOfName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectIndexOfObject = record
    Self: TjsObj;
    Obj: TjsObj;
  end;
  PjsInObjectIndexOfObject = ^TjsInObjectIndexOfObject;

  TjsOutObjectIndexOfObject = record
    Idx: TjsInteger;
  end;
  PjsOutObjectIndexOfObject = ^TjsOutObjectIndexOfObject;

  TjsObjectIndexOfObject = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAdd = record
    Self: TjsObj;
    Name: Tjsvc256;
    Obj: TjsObj;
  end;
  PjsInObjectAdd = ^TjsInObjectAdd;

  TjsOutObjectAdd = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAdd = ^TjsOutObjectAdd;

  TjsObjectAdd = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAddBoolean = record
    Self: TjsObj;
    Name: Tjsvc256;
    Bool: TjsBool;
  end;
  PjsInObjectAddBoolean = ^TjsInObjectAddBoolean;

  TjsOutObjectAddBoolean = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAddBoolean = ^TjsOutObjectAddBoolean;

  TjsObjectAddBoolean = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAddDouble = record
    Self: TjsObj;
    Name: Tjsvc256;
    Dbl: TjsDouble;
  end;
  PjsInObjectAddDouble = ^TjsInObjectAddDouble;

  TjsOutObjectAddDouble = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAddDouble = ^TjsOutObjectAddDouble;

  TjsObjectAddDouble = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAddInteger = record
    Self: TjsObj;
    Name: Tjsvc256;
    Int: TjsInteger;
  end;
  PjsInObjectAddInteger = ^TjsInObjectAddInteger;

  TjsOutObjectAddInteger = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAddInteger = ^TjsOutObjectAddInteger;

  TjsObjectAddInteger = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAddString = record
    Self: TjsObj;
    Name: Tjsvc256;
    Str: TjsvcX;
  end;
  PjsInObjectAddString = ^TjsInObjectAddString;

  TjsOutObjectAddString = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAddString = ^TjsOutObjectAddString;

  TjsObjectAddString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectAddWideString = record
    Self: TjsObj;
    Name: Tjsvc256;
    WStr: TjsWStr;
  end;
  PjsInObjectAddWideString = ^TjsInObjectAddWideString;

  TjsOutObjectAddWideString = record
    Idx: TjsInteger;
  end;
  PjsOutObjectAddWideString = ^TjsOutObjectAddWideString;

  TjsObjectAddWideString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectGet = record
    Self: TjsObj;
    Idx: TjsInteger;
  end;
  PjsInObjectGet = ^TjsInObjectGet;

  TjsInObjectGetByName = record
    Self: TjsObj;
    Name: Tjsvc256;
  end;
  PjsInObjectGetByName = ^TjsInObjectGetByName;

  TjsOutObjectGetBoolean = record
    Bool: TjsBool;
  end;
  PjsOutObjectGetBoolean = ^TjsOutObjectGetBoolean;

  TjsObjectGetBoolean = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectGetBooleanByName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutObjectGetDouble = record
    Dbl: TjsDouble;
  end;
  PjsOutObjectGetDouble = ^TjsOutObjectGetDouble;

  TjsObjectGetDouble = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectGetDoubleByName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutObjectGetInteger = record
    Int: TjsInteger;
  end;
  PjsOutObjectGetInteger = ^TjsOutObjectGetInteger;

  TjsObjectGetInteger = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectGetIntegerByName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutObjectGetString = record
    Str: TjsvcX;
  end;
  PjsOutObjectGetString = ^TjsOutObjectGetString;

  TjsObjectGetString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectGetStringByName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutObjectGetWideString = record
    WStr: TjsWStr;
  end;
  PjsOutObjectGetWideString = ^TjsOutObjectGetWideString;

  TjsObjectGetWideString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectGetWideStringByName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectDelete = record
    Self: TjsObj;
    Idx: TjsInteger;
  end;
  PjsInObjectDelete = ^TjsInObjectDelete;

  TjsOutObjectDelete = record
    Res: TjsSmallInt;
  end;
  PjsOutObjectDelete = ^TjsOutObjectDelete;

  TjsObjectDelete = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectGenerate = record
    Self: TjsObj;
    UseHash: TjsBool;
  end;
  PjsInObjectGenerate = ^TjsInObjectGenerate;

  TjsOutObjectGenerate = record
    Obj: TjsObj;
  end;
  PjsOutObjectGenerate = ^TjsOutObjectGenerate;

  TjsObjectGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsObjectSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ TlkJSONobjectmethod }

  TjsInObjectMethodObjValue = record
    Self: TjsObj;
  end;
  PjsInObjectMethodObjValue = ^TjsInObjectMethodObjValue;

  TjsOutObjectMethodObjValue = record
    Obj: TjsObj;
  end;
  PjsOutObjectMethodObjValue = ^TjsOutObjectMethodObjValue;

  TjsObjectMethodObjValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectMethodName = record
    Self: TjsObj;
    Name: Tjsvc256;
  end;
  PjsInObjectMethodName = ^TjsInObjectMethodName;

  TjsOutObjectMethodName = record
    Name: Tjsvc256;
  end;
  PjsOutObjectMethodName = ^TjsOutObjectMethodName;

  TjsObjectMethodName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInObjectMethodGenerate = record
    Self: TjsObj;
    Name: Tjsvc256;
    Obj: TjsObj;
  end;
  PjsInObjectMethodGenerate = ^TjsInObjectMethodGenerate;

  TjsOutObjectMethodGenerate = record
    Obj: TjsObj;
  end;
  PjsOutObjectMethodGenerate = ^TjsOutObjectMethodGenerate;

  TjsObjectMethodGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

 { TlkJSONList }

  TjsInListAdd = record
    Self: TjsObj;
    Obj: TjsObj;
  end;
  PjsInListAdd = ^TjsInListAdd;

  TjsOutListAdd = record
    Idx: TjsInteger;
  end;
  PjsOutListAdd = ^TjsOutListAdd;

  TjsListAdd = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListAddBoolean = record
    Self: TjsObj;
    Bool: TjsBool;
  end;
  PjsInListAddBoolean = ^TjsInListAddBoolean;

  TjsOutListAddBoolean = record
    Idx: TjsInteger;
  end;
  PjsOutListAddBoolean = ^TjsOutListAddBoolean;

  TjsListAddBoolean = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListAddDouble = record
    Self: TjsObj;
    Dbl: TjsDouble;
  end;
  PjsInListAddDouble = ^TjsInListAddDouble;

  TjsOutListAddDouble = record
    Idx: TjsInteger;
  end;
  PjsOutListAddDouble = ^TjsOutListAddDouble;

  TjsListAddDouble = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListAddInteger = record
    Self: TjsObj;
    Int: TjsInteger;
  end;
  PjsInListAddInteger = ^TjsInListAddInteger;

  TjsOutListAddInteger = record
    Idx: TjsInteger;
  end;
  PjsOutListAddInteger = ^TjsOutListAddInteger;

  TjsListAddInteger = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListAddString = record
    Self: TjsObj;
    Str: TjsvcX;
  end;
  PjsInListAddString = ^TjsInListAddString;

  TjsOutListAddString = record
    Idx: TjsInteger;
  end;
  PjsOutListAddString = ^TjsOutListAddString;

  TjsListAddString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListAddWideString = record
    Self: TjsObj;
    WStr: TjsWStr;
  end;
  PjsInListAddWideString = ^TjsInListAddWideString;

  TjsOutListAddWideString = record
    Idx: TjsInteger;
  end;
  PjsOutListAddWideString = ^TjsOutListAddWideString;

  TjsListAddWideString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListDelete = record
    Self: TjsObj;
    Idx: TjsInteger;
  end;
  PjsInListDelete = ^TjsInListDelete;

  TjsOutListDelete = record
    Res: TjsSmallInt;
  end;
  PjsOutListDelete = ^TjsOutListDelete;

  TjsListDelete = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListIndexOfObject = record
    Self: TjsObj;
    Obj: TjsObj;
  end;
  PjsInListIndexOfObject = ^TjsInListIndexOfObject;

  TjsOutListIndexOfObject = record
    Idx: TjsInteger;
  end;
  PjsOutListIndexOfObject = ^TjsOutListIndexOfObject;

  TjsListIndexOfObject = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInListGenerate = record
    Self: TjsObj;
  end;
  PjsInListGenerate = ^TjsInListGenerate;

  TjsOutListGenerate = record
    Obj: TjsObj;
  end;
  PjsOutListGenerate = ^TjsOutListGenerate;

  TjsListGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsListSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsListSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ TlkJSONcustomlist }

  TjsInCustomListGet = record
    Self: TjsObj;
    Idx: TjsInteger;
  end;
  PjsInCustomListGet = ^TjsInCustomListGet;

  TjsOutCustomListGetBoolean = record
    Bool: TjsBool;
  end;
  PjsOutCustomListGetBoolean = ^TjsOutCustomListGetBoolean;

  TjsCustomListGetBoolean = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutCustomListGetDouble = record
    Dbl: TjsDouble;
  end;
  PjsOutCustomListGetDouble = ^TjsOutCustomListGetDouble;

  TjsCustomListGetDouble = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutCustomListGetInteger = record
    Int: TjsInteger;
  end;
  PjsOutCustomListGetInteger = ^TjsOutCustomListGetInteger;

  TjsCustomListGetInteger = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutCustomListGetString = record
    Str: TjsvcX;
  end;
  PjsOutCustomListGetString = ^TjsOutCustomListGetString;

  TjsCustomListGetString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutCustomListGetWideString = record
    WStr: TjsWStr;
  end;
  PjsOutCustomListGetWideString = ^TjsOutCustomListGetWideString;

  TjsCustomListGetWideString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ TlkJSONbase }

  TjsInBaseDispose = record
    Self: TjsObj;
  end;
  PjsInBaseDispose = ^TjsInBaseDispose;

  TjsOutBaseDispose = record
    Res: TjsSmallInt;
  end;
  PjsOutBaseDispose = ^TjsOutBaseDispose;

  TjsBaseDispose = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBaseField = record
    Self: TjsObj;
    Name: Tjsvc256;
  end;
  PjsInBaseField = ^TjsInBaseField;

  TjsOutBaseField = record
    Obj: TjsObj;
  end;
  PjsOutBaseField = ^TjsOutBaseField;

  TjsBaseField = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsOutBaseCount = record
    Cnt: TjsInteger;
  end;
  PjsOutBaseCount = ^TjsOutBaseCount;

  TjsBaseCount = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBaseParent = record
    Self: TjsObj;
  end;
  PjsInBaseParent = ^TjsInBaseParent;

  TjsOutBaseParent = record
    Obj: TjsObj;
  end;
  PjsOutBaseParent = ^TjsOutBaseParent;

  TjsBaseParent = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBaseChild = record
    Self: TjsObj;
    Idx: TjsInteger;
    Obj: TjsObj;
  end;
  PjsInBaseChild = ^TjsInBaseChild;

  TjsOutBaseChild = record
    Obj: TjsObj;
  end;
  PjsOutBaseChild = ^TjsOutBaseChild;

  TjsBaseChild = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBaseValue = record
    Self: TjsObj;
    SVal: TjsvcX;
  end;
  PjsInBaseValue = ^TjsInBaseValue;

  TjsOutBaseValue = record
    SVal: TjsvcX;
  end;
  PjsOutBaseValue = ^TjsOutBaseValue;

  TjsBaseValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBaseWideValue = record
    Self: TjsObj;
    WVal: TjsWStr;
  end;
  PjsInBaseWideValue = ^TjsInBaseWideValue;

  TjsOutBaseWideValue = record
    WVal: TjsWStr;
  end;
  PjsOutBaseWideValue = ^TjsOutBaseWideValue;

  TjsBaseWideValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsBaseSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsBaseSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBooleanValue = record
    Self: TjsObj;
    Bool: TjsBool;
  end;
  PjsInBooleanValue = ^TjsInBooleanValue;

  TjsOutBooleanValue = record
    Bool: TjsBool;
  end;
  PjsOutBooleanValue = ^TjsOutBooleanValue;

  TjsBooleanValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInBooleanGenerate = record
    Self: TjsObj;
    Bool: TjsBool;
  end;
  PjsInBooleanGenerate = ^TjsInBooleanGenerate;

  TjsBooleanGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsBooleanSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsBooleanSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInNumberValue = record
    Self: TjsObj;
    Dbl: TjsDouble;
  end;
  PjsInNumberValue = ^TjsInNumberValue;

  TjsOutNumberValue = record
    Dbl: TjsDouble;
  end;
  PjsOutNumberValue = ^TjsOutNumberValue;

  TjsNumberValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
        override;
  end;

  TjsInNumberGenerate = record
    Self: TjsObj;
    Dbl: TjsDouble;
  end;
  PjsInNumberGenerate = ^TjsInNumberGenerate;

  TjsNumberGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsNumberSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsNumberSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInStringValue = record
    Self: TjsObj;
    Str: TjsvcX;
  end;
  PjsInStringValue = ^TjsInStringValue;

  TjsOutStringValue = record
    Str: TjsvcX;
  end;
  PjsOutStringValue = ^TjsOutStringValue;

  TjsStringValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInStringWideValue = record
    Self: TjsObj;
    WStr: TjsWStr;
  end;
  PjsInStringWideValue = ^TjsInStringWideValue;

  TjsOutStringWideValue = record
    WStr: TjsWStr;
  end;
  PjsOutStringWideValue = ^TjsOutStringWideValue;

  TjsStringWideValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInStringGenerate = record
    Self: TjsObj;
    Str: TjsvcX;
  end;
  PjsInStringGenerate = ^TjsInStringGenerate;

  TjsStringGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInStringWideGenerate = record
    Self: TjsObj;
    WStr: TjsWStr;
  end;
  PjsInStringWideGenerate = ^TjsInStringWideGenerate;

  TjsStringWideGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsStringSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsStringSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInNullValue = record
    Self: TjsObj;
  end;
  PjsInNullValue = ^TjsInNullValue;

  TjsOutNullValue = record
    Res: TjsSmallInt;
  end;
  PjsOutNullValue = ^TjsOutNullValue;

  TjsNullValue = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInNullGenerate = record
    Self: TjsObj;
  end;
  PjsInNullGenerate = ^TjsInNullGenerate;

  TjsNullGenerate = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsNullSelfType = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsNullSelfTypeName = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ TlkJSON }

  TjsInParseText = record
    Text: TjsWStr;
    Conv: TjsBool;
  end;
  PjsInParseText = ^TjsInParseText;

  TjsOutParseText = record
    Obj: TjsObj;
  end;
  PjsOutParseText = ^TjsOutParseText;

  TjsParseText = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInParseString = record
    Str: TjsvcX;
    Conv: TjsBool;
  end;
  PjsInParseString = ^TjsInParseString;

  TjsOutParseString = record
    Obj: TjsObj;
  end;
  PjsOutParseString = ^TjsOutParseString;

  TjsParseString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInGenerateText = record
    Obj: TjsObj;
    Conv: TjsBool;
  end;
  PjsInGenerateText = ^TjsInGenerateText;

  TjsOutGenerateText = record
    Text: TjsWStr;
  end;
  PjsOutGenerateText = ^TjsOutGenerateText;

  TjsGenerateText = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

  TjsInGenerateString = record
    Obj: TjsObj;
    Conv: TjsBool;
  end;
  PjsInGenerateString = ^TjsInGenerateString;

  TjsOutGenerateString = record
    Str: TjsvcX;
  end;
  PjsOutGenerateString = ^TjsOutGenerateString;

  TjsGenerateString = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ Readable }

  TjsInReadableText = record
    Obj: TjsObj;
    Level: TjsInteger;
    Conv: TjsBool;
  end;
  PjsInReadableText = ^TjsInReadableText;

  TjsOutReadableText = record
    Text: TjsWStr;
  end;
  PjsOutReadableText = ^TjsOutReadableText;

  TjsReadableText = class(TjsFunction)
    procedure execute
      (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
      override;
  end;

{ BLOB }

procedure ReadBlobToStream
  (AStream: TStream; AStatus: IStatus; AContext: IExternalContext;
   ABlob: ISC_QUADPtr);
procedure WriteStreamToBlob
  (AStream: TStream; AStatus: IStatus; AContext: IExternalContext;
   ABlob: ISC_QUADPtr);

implementation

{ BLOB }

procedure ReadBlobToStream
  (AStream: TStream; AStatus: IStatus; AContext: IExternalContext;
   ABlob: ISC_QUADPtr);
var
  AttachmentID: IAttachment;
  TransactionID: ITransaction;
  Blob: IBlob;
  Buffer: array [0 .. 32767] of Byte;
  Read: Integer;
begin
  AttachmentID := AContext.getAttachment(AStatus);
  TransactionID := AContext.getTransaction(AStatus);
  Blob := Nil;
  try
    Blob := AttachmentID.openBlob(AStatus, TransactionID, ABlob, 0, Nil);
    while True do
    begin
      case Blob.getSegment(AStatus, SizeOf(Buffer), @Buffer, @Read) of
        IStatus.RESULT_OK,
        IStatus.RESULT_SEGMENT:
          AStream.WriteBuffer(Buffer, Read);
      else
        break;
      end;
    end;
    Blob.close(AStatus);
  finally
    if Assigned(Blob) then Blob.release;
    TransactionID.release;
    AttachmentID.release;
  end;
end;

procedure WriteStreamToBlob
  (AStream: TStream; AStatus: IStatus; AContext: IExternalContext;
   ABlob: ISC_QUADPtr);
var
  AttachmentID: IAttachment;
  TransactionID: ITransaction;
  Blob: IBlob;
  Buffer: array [0 .. 32767] of Byte;
  bSize: Integer = 32768;
  sSize: Integer;
  Read: Integer;
begin
  AttachmentID := AContext.getAttachment(AStatus);
  TransactionID := AContext.getTransaction(AStatus);
  Blob := Nil;
  try
    sSize := AStream.Size;
    Blob := AttachmentID.createBlob(AStatus, TransactionID, ABlob, 0, Nil);
    AStream.Position := 0;
    while sSize <> 0 do
    begin
      if sSize > bSize then
        Read := bSize else
        Read := sSize;
      AStream.ReadBuffer(Buffer, Read);
      Blob.putSegment(AStatus, Read, @Buffer[0]);
      Dec(sSize, Read);
    end;
    Blob.close(AStatus);
  finally
    if Assigned(Blob) then Blob.release;
    TransactionID.release;
    AttachmentID.release;
  end;
end;

{ TjsFunction }

procedure TjsFunction.dispose;
begin
end;

procedure TjsFunction.getCharSet
  (AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar;
   ANameSize: Cardinal);
begin
end;

{ TjsFunctionFactory }

procedure TjsFunctionFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.dispose;
begin
  inherited dispose;
end;

function TjsFunctionFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.newItem
  (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata):
  IExternalFunction;
begin
  Result := {$IFNDEF GENERIC}_T{$ELSE}{$ENDIF}(
    inherited newItem(AStatus, AContext, AMetadata)
  );
end;

procedure TjsFunctionFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.setup
  (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
   AInBuilder, AOutBuilder: IMetadataBuilder);
begin
  inherited setup(AStatus, AContext, AMetadata, AInBuilder, AOutBuilder);
end;

{ TjsProcedure }

procedure TjsProcedure.dispose;
begin
end;

procedure TjsProcedure.getCharSet
  (AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin
end;

{ TjsProcedureFactory }

procedure TjsProcedureFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.dispose;
begin
  inherited Destroy;
end;

function TjsProcedureFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.newItem
  (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata):
  IExternalProcedure;
begin
  Result := {$IFNDEF GENERIC}_T{$ELSE}{$ENDIF}(
    inherited newItem(AStatus, AContext, AMetadata)
  );
end;

procedure TjsProcedureFactory{$IFNDEF GENERIC}<_T>{$ELSE}{$ENDIF}.setup
  (AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
   AInBuilder, AOutBuilder: IMetadataBuilder);
begin
  inherited setup(AStatus, AContext, AMetadata, AInBuilder, AOutBuilder);
end;

{ TjsObject }

procedure TjsObjectNew.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectNew;
  O: PjsOutObjectNew;
begin
  I := PjsInObjectNew(AInMsg);
  if I^.UseHash.Null then I^.UseHash.Val := True;
  O := PjsOutObjectNew(AOutMsg);
  try
    O^.Self.Ptr :=
      TjsPtr(NativeIntPtr(TlkJSONobject.Create(I^.UseHash.Val)));
    O^.Self.Null := False;
  except
    O^.Self.Null := True;
    raise;
  end;
end;

procedure TjsObjectDispose.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectDispose;
  O: PjsOutObjectDispose;
begin
  I := PjsInObjectDispose(AInMsg);
  O := PjsOutObjectDispose(AOutMsg);
  O^.Res.Val := 1; // err
  O^.Res.Null := False;
  if I^.Self.Null then
    Exit;
  try
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Free;
    O^.Res.Val := 0; // sucess
  except
    raise;
  end;
end;

procedure TjsObjectAdd.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAdd;
  O: PjsOutObjectAdd;
begin
  I := PjsInObjectAdd(AInMsg);
  O := PjsOutObjectAdd(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null or I^.Obj.Null then
    Exit;
  O^.Idx.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      Add(I^.Name.Val, TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr))));
end;

procedure TjsObjectAddBoolean.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAddBoolean;
  O: PjsOutObjectAddBoolean;
begin
  I := PjsInObjectAddBoolean(AInMsg);
  O := PjsOutObjectAddBoolean(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.Bool.Null then
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, I^.Bool.Val);
end;

procedure TjsObjectAddDouble.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAddDouble;
  O: PjsOutObjectAddDouble;
begin
  I := PjsInObjectAddDouble(AInMsg);
  O := PjsOutObjectAddDouble(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.Dbl.Null then
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, I^.Dbl.Val);
end;

procedure TjsObjectAddInteger.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAddInteger;
  O: PjsOutObjectAddInteger;
begin
  I := PjsInObjectAddInteger(AInMsg);
  O := PjsOutObjectAddInteger(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.Int.Null then
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, I^.Int.Val);
end;

procedure TjsObjectAddString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAddString;
  O: PjsOutObjectAddString;
begin
  I := PjsInObjectAddString(AInMsg);
  O := PjsOutObjectAddString(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.Str.Null then
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, String(I^.Str.Val));
end;

procedure TjsObjectAddWideString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectAddWideString;
  O: PjsOutObjectAddWideString;
  Stream: TStringStream;
begin
  I := PjsInObjectAddWideString(AInMsg);
  O := PjsOutObjectAddWideString(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.WStr.Null then
    O^.Idx.Val :=
      TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        Add(I^.Name.Val, TlkJSONnull.Generate())
  else
  begin
    Stream := TStringStream.Create;
    try
      ReadBlobToStream(Stream, AStatus, AContext, @(I^.WStr.Ptr));
      O^.Idx.Val :=
        TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Add(I^.Name.Val, Stream.DataString);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TjsObjectDelete.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectDelete;
  O: PjsOutObjectDelete;
begin
  I := PjsInObjectDelete(AInMsg);
  O := PjsOutObjectDelete(AOutMsg);
  O^.Res.Val := 1; // err
  O^.Res.Null := False;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  try
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Delete(I^.Idx.Val);
    O^.Res.Val := 0; // sucess
  except
    raise;
  end;
end;

procedure TjsObjectIndexOfName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectIndexOfName;
  O: PjsOutObjectIndexOfName;
begin
  I := PjsInObjectIndexOfName(AInMsg);
  O := PjsOutObjectIndexOfName(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  O^.Idx.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).IndexOfName(I^.Name.Val);
end;

procedure TjsObjectIndexOfObject.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectIndexOfObject;
  O: PjsOutObjectIndexOfObject;
begin
  I := PjsInObjectIndexOfObject(AInMsg);
  O := PjsOutObjectIndexOfObject(AOutMsg);
  O^.Idx.Null := True;
  if I^.Self.Null or I^.Obj.Null then
    Exit;
  O^.Idx.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      IndexOfObject(TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr))));
  O^.Idx.Null := False;
end;

procedure TjsObjectField.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectField;
  O: PjsOutObjectField;
begin
  I := PjsInObjectField(AInMsg);
  O := PjsOutObjectField(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  if I^.Obj.Null then
  // Get
  begin
    O^.Obj.Ptr :=
      TjsPtr(NativeIntPtr(
        TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Field[I^.Name.Val]));
    O^.Obj.Null := False;
  end
  else
  // Set
  begin
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Field[I^.Name.Val] :=
      TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr)));
    O^.Obj.Ptr := I^.Obj.Ptr;
    O^.Obj.Null := False;
  end;
end;

procedure TjsObjectGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGenerate;
  O: PjsOutObjectGenerate;
begin
  I := PjsInObjectGenerate(AInMsg);
  if I^.UseHash.Null then I^.UseHash.Val := True;
  O := PjsOutObjectGenerate(AOutMsg);
  try
    if I^.Self.Null then // class function
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONobject.Generate(I^.UseHash.Val)))
    else
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate(I^.UseHash.Val)));
    O^.Obj.Null := False;
  except
    O^.Obj.Null := True;
    raise;
  end;
end;

procedure TjsObjectSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONobject.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsObjectSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONobject.SelfTypeName else
    S := TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

procedure TjsObjectFieldByIndex.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectFieldByIndex;
  O: PjsOutObjectFieldByIndex;
begin
  I := PjsInObjectFieldByIndex(AInMsg);
  O := PjsOutObjectFieldByIndex(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  if I^.Obj.Null then
  // GetFieldByIndex
  begin
    O^.Obj.Ptr :=
      TjsPtr(NativeIntPtr(
        TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).FieldByIndex[I^.Idx.Val]));
    O^.Obj.Null := False;
  end
  else
  // SetFieldByIndex
  begin
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).FieldByIndex[I^.Idx.Val] :=
      TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr)));
    O^.Obj.Ptr := I^.Obj.Ptr;
    O^.Obj.Null := False;
  end;
end;

procedure TjsObjectNameOf.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectNameOf;
  O: PjsOutObjectNameOf;
  S: String;
begin
  I := PjsInObjectNameOf(AInMsg);
  O := PjsOutObjectNameOf(AOutMsg);
  O^.Name.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  S :=
    String(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).NameOf[I^.Idx.Val]);
  O^.Name.Len := Length(S);
  O^.Name.Val := S;
  O^.Name.Null := False;
end;

procedure TjsObjectGetBoolean.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGet;
  O: PjsOutObjectGetBoolean;
  B: Boolean = False;
begin
  I := PjsInObjectGet(AInMsg);
  O := PjsOutObjectGetBoolean(AOutMsg);
  O^.Bool.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Bool.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getBoolean(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Bool.Null := B;
end;

procedure TjsObjectGetDouble.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGet;
  O: PjsOutObjectGetDouble;
  B: Boolean = False;
begin
  I := PjsInObjectGet(AInMsg);
  O := PjsOutObjectGetDouble(AOutMsg);
  O^.Dbl.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Dbl.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getDouble(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Dbl.Null := B;
end;

procedure TjsObjectGetInteger.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGet;
  O: PjsOutObjectGetInteger;
  B: Boolean = False;
begin
  I := PjsInObjectGet(AInMsg);
  O := PjsOutObjectGetInteger(AOutMsg);
  O^.Int.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Int.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getInt(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Int.Null := B;
end;

procedure TjsObjectGetString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGet;
  O: PjsOutObjectGetString;
  S: String;
  B: Boolean = False;
begin
  I := PjsInObjectGet(AInMsg);
  O := PjsOutObjectGetString(AOutMsg);
  O^.Str.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  S :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getString(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Str.Len := Length(S);
  O^.Str.Val := S;
  O^.Str.Null := B;
end;

procedure TjsObjectGetWideString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGet;
  O: PjsOutObjectGetWideString;
  Stream: TStringStream;
  B: Boolean = False;
begin
  I := PjsInObjectGet(AInMsg);
  O := PjsOutObjectGetWideString(AOutMsg);
  O^.WStr.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  Stream := TStringStream.Create;
  try
    Stream.WriteString(
       TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
         getString(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF})
      );
    WriteStreamToBlob(Stream, AStatus, AContext, @(O^.WStr.Ptr));
    O^.WStr.Null := B;
  finally
    Stream.Free;
  end;
end;

procedure TjsObjectGetBooleanByName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGetByName;
  O: PjsOutObjectGetBoolean;
  B: Boolean = False;
begin
  I := PjsInObjectGetByName(AInMsg);
  O := PjsOutObjectGetBoolean(AOutMsg);
  O^.Bool.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  O^.Bool.Val :=
     TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getBoolean(I^.Name.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Bool.Null := B;
end;

procedure TjsObjectGetDoubleByName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGetByName;
  O: PjsOutObjectGetDouble;
  B: Boolean = False;
begin
  I := PjsInObjectGetByName(AInMsg);
  O := PjsOutObjectGetDouble(AOutMsg);
  O^.Dbl.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  O^.Dbl.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getDouble(I^.Name.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Dbl.Null := B;
end;

procedure TjsObjectGetIntegerByName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGetByName;
  O: PjsOutObjectGetInteger;
  B: Boolean = False;
begin
  I := PjsInObjectGetByName(AInMsg);
  O := PjsOutObjectGetInteger(AOutMsg);
  O^.Int.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  O^.Int.Val :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getInt(I^.Name.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Int.Null := B;
end;

procedure TjsObjectGetStringByName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGetByName;
  O: PjsOutObjectGetString;
  S: String;
  B: Boolean = False;
begin
  I := PjsInObjectGetByName(AInMsg);
  O := PjsOutObjectGetString(AOutMsg);
  O^.Str.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  S :=
    TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getString(I^.Name.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Str.Len := Length(S);
  O^.Str.Val := S;
  O^.Str.Null := B;
end;

procedure TjsObjectGetWideStringByName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectGetByName;
  O: PjsOutObjectGetWideString;
  Stream: TStringStream;
  B: Boolean = False;
begin
  I := PjsInObjectGetByName(AInMsg);
  O := PjsOutObjectGetWideString(AOutMsg);
  O^.WStr.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  Stream := TStringStream.Create;
  try
    Stream.WriteString(
       TlkJSONobject(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
        getString(I^.Name.Val{$IFDEF NULL_SQL}, B{$ENDIF})
      );
    WriteStreamToBlob(Stream, AStatus, AContext, @(O^.WStr));
    O^.WStr.Null := B;
  finally
    Stream.Free;
  end;
end;

{ TlkJSONobjectmethod }

procedure TjsObjectMethodObjValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectMethodObjValue;
  O: PjsOutObjectMethodObjValue;
begin
  I := PjsInObjectMethodObjValue(AInMsg);
  O := PjsOutObjectMethodObjValue(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null then Exit;
  O^.Obj.Ptr :=
    TjsPtr(NativeIntPtr(
      TlkJSONobjectmethod(NativeIntPtr(TjsPtr(I^.Self.Ptr))).ObjValue));
  O^.Obj.Null := False;
end;

procedure TjsObjectMethodName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectMethodName;
  O: PjsOutObjectMethodName;
  S: String;
begin
  I := PjsInObjectMethodName(AInMsg);
  O := PjsOutObjectMethodName(AOutMsg);
  O^.Name.Null := True;
  if I^.Self.Null then Exit;
  if I^.Name.Null then
  // FName
  begin
    S :=
      String(TlkJSONobjectmethod(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Name);
    O^.Name.Len := Length(S);
    O^.Name.Val := S;
    O^.Name.Null := False;
  end
  else
  // SetName
  begin
    TlkJSONobjectmethod(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Name :=
      I^.Name.Val;
    O^.Name.Len := I^.Name.Len;
    O^.Name.Val := I^.Name.Val;
    O^.Name.Null := False;
  end;
end;

procedure TjsObjectMethodGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInObjectMethodGenerate;
  O: PjsOutObjectMethodGenerate;
begin
  I := PjsInObjectMethodGenerate(AInMsg);
  O := PjsOutObjectMethodGenerate(AOutMsg);
  O^.Obj.Null := True;
  if I^.Name.Null or I^.Obj.Null then
    Exit;
  try
    if I^.Self.Null then // class function
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONobjectmethod.
          Generate(I^.Name.Val, TlkJSONobject(NativeIntPtr(TjsPtr(I^.Obj.Ptr))))))
    else
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(
          TlkJSONobjectmethod(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
            Generate(I^.Name.Val, TlkJSONobject(NativeIntPtr(TjsPtr(I^.Obj.Ptr))))
        ));
    O^.Obj.Null := False;
  except
    O^.Obj.Null := True;
    raise;
  end;
end;

{ TjsList}

procedure TjsListAdd.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAdd;
  O: PjsOutListAdd;
begin
  I := PjsInListAdd(AInMsg);
  O := PjsOutListAdd(AOutMsg);
  O^.Idx.Null := True;
  if I^.Self.Null or I^.Obj.Null then
    Exit;
  O^.Idx.Val :=
    TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      Add(TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr))));
  O^.Idx.Null := False;
end;

procedure TjsListAddBoolean.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAddBoolean;
  O: PjsOutListAddBoolean;
begin
  I := PjsInListAddBoolean(AInMsg);
  O := PjsOutListAddBoolean(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null then
    Exit;
  if I^.Bool.Null then
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(I^.Bool.Val);
end;

procedure TjsListAddDouble.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAddDouble;
  O: PjsOutListAddDouble;
begin
  I := PjsInListAddDouble(AInMsg);
  O := PjsOutListAddDouble(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null then
    Exit;
  if I^.Dbl.Null then
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(I^.Dbl.Val);
end;

procedure TjsListAddInteger.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAddInteger;
  O: PjsOutListAddInteger;
begin
  I := PjsInListAddInteger(AInMsg);
  O := PjsOutListAddInteger(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null then
    Exit;
  if I^.Int.Null then
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(I^.Int.Val);
end;

procedure TjsListAddString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAddString;
  O: PjsOutListAddString;
begin
  I := PjsInListAddString(AInMsg);
  O := PjsOutListAddString(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null then
    Exit;
  if I^.Str.Null then
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(TlkJSONnull.Generate())
  else
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(String(I^.Str.Val));
end;

procedure TjsListAddWideString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListAddWideString;
  O: PjsOutListAddWideString;
  Stream: TStringStream;
begin
  I := PjsInListAddWideString(AInMsg);
  O := PjsOutListAddWideString(AOutMsg);
  O^.Idx.Val := -1;
  O^.Idx.Null := False;
  if I^.Self.Null then
    Exit;
  if I^.WStr.Null then
    O^.Idx.Val :=
      TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Add(TlkJSONnull.Generate())
  else
  begin
    Stream := TStringStream.Create;
    try
      ReadBlobToStream(Stream, AStatus, AContext, @(I^.WStr.Ptr));
      O^.Idx.Val :=
        TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Add(Stream.DataString);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TjsListDelete.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListDelete;
  O: PjsOutListDelete;
begin
  I := PjsInListDelete(AInMsg);
  O := PjsOutListDelete(AOutMsg);
  O^.Res.Val := 1; // err
  O^.Res.Null := False;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  try
    TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Delete(I^.Idx.Val);
    O^.Res.Val := 0; // sucess
  except
    raise;
  end;
end;

procedure TjsListIndexOfObject.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListIndexOfObject;
  O: PjsOutListIndexOfObject;
begin
  I := PjsInListIndexOfObject(AInMsg);
  O := PjsOutListIndexOfObject(AOutMsg);
  O^.Idx.Null := True;
  if I^.Self.Null or I^.Obj.Null then
    Exit;
  O^.Idx.Val :=
    TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      IndexOf{Object}(TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr))));
  O^.Idx.Null := False;
end;

procedure TjsListGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInListGenerate;
  O: PjsOutListGenerate;
begin
  I := PjsInListGenerate(AInMsg);
  O := PjsOutListGenerate(AOutMsg);
  try
    if I^.Self.Null then // class function
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONlist.Generate()))
    else
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate()));
    O^.Obj.Null := False;
  except
    O^.Obj.Null := True;
    raise;
  end;
end;

procedure TjsListSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONlist.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsListSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONlist.SelfTypeName else
    S := TlkJSONlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

{ TlkJSONCustomList }

procedure TjsCustomListGetBoolean.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInCustomListGet;
  O: PjsOutCustomListGetBoolean;
  B: Boolean = False;
begin
  I := PjsInCustomListGet(AInMsg);
  O := PjsOutCustomListGetBoolean(AOutMsg);
  O^.Bool.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Bool.Val :=
    TlkJSONcustomlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getBoolean(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Bool.Null := B;
end;

procedure TjsCustomListGetDouble.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInCustomListGet;
  O: PjsOutCustomListGetDouble;
  B: Boolean = False;
begin
  I := PjsInCustomListGet(AInMsg);
  O := PjsOutCustomListGetDouble(AOutMsg);
  O^.Dbl.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Dbl.Val :=
    TlkJSONcustomlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getDouble(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Dbl.Null := B;
end;

procedure TjsCustomListGetInteger.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInCustomListGet;
  O: PjsOutCustomListGetInteger;
  B: Boolean = False;
begin
  I := PjsInCustomListGet(AInMsg);
  O := PjsOutCustomListGetInteger(AOutMsg);
  O^.Int.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  O^.Int.Val :=
    TlkJSONcustomlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getInt(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Int.Null := B;
end;

procedure TjsCustomListGetString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInCustomListGet;
  O: PjsOutCustomListGetString;
  S: String;
  B: Boolean = False;
begin
  I := PjsInCustomListGet(AInMsg);
  O := PjsOutCustomListGetString(AOutMsg);
  O^.Str.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  S :=
    TlkJSONcustomlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
      getString(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF});
  O^.Str.Len := Length(S);
  O^.Str.Val := S;
  O^.Str.Null := B;
end;

procedure TjsCustomListGetWideString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInCustomListGet;
  O: PjsOutCustomListGetWideString;
  Stream: TStringStream;
  B: Boolean = False;
begin
  I := PjsInCustomListGet(AInMsg);
  O := PjsOutCustomListGetWideString(AOutMsg);
  O^.WStr.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  Stream := TStringStream.Create;
  try
    Stream.WriteString(
       TlkJSONcustomlist(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
         getString(I^.Idx.Val{$IFDEF NULL_SQL}, B{$ENDIF})
      );
    WriteStreamToBlob(Stream, AStatus, AContext, @(O^.WStr.Ptr));
    O^.WStr.Null := B;
  finally
    Stream.Free;
  end;
end;

{ TlkJSONbase }

procedure TjsBaseDispose.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseDispose;
  O: PjsOutBaseDispose;
begin
  I := PjsInBaseDispose(AInMsg);
  O := PjsOutBaseDispose(AOutMsg);
  O^.Res.Val := 1; // err
  O^.Res.Null := False;
  if I^.Self.Null then
    Exit;
  try
    TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Free;
    O^.Res.Val := 0; // sucess
  except
    raise;
  end;
end;

procedure TjsBaseField.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseField;
  O: PjsOutBaseField;
  P: TlkJSONbase;
  N: Integer;
begin
  I := PjsInBaseField(AInMsg);;
  O := PjsOutBaseField(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null or I^.Name.Null then
    Exit;
  case TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType of
    jsBase,
    jsNumber,
    jsString,
    jsBoolean,
    jsNull:
      O^.Obj.Ptr :=
        TjsPtr(NativeIntPtr(
          TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Field[I^.Name.Val]));
    jsList,
    jsObject:
      begin
        P := Nil;
        if TryStrToInt(I^.Name.Val, N) then
          P := TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Field[N];
        if P = Nil then
          P := TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Field[I^.Name.Val];
        O^.Obj.Ptr := TjsPtr(NativeIntPtr(P));
      end;
  end;
  O^.Obj.Null := False;
end;

procedure TjsBaseCount.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsOutBaseCount;
begin
  I := PjsSelf(AInMsg);
  O := PjsOutBaseCount(AOutMsg);
  O^.Cnt.Null := True;
  if I^.Self.Null then Exit;
  O^.Cnt.Val :=
    TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Count;
  O^.Cnt.Null := False;
end;

procedure TjsBaseParent.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseParent;
  O: PjsOutBaseParent;
  P: TlkJSONbase;
begin
  I := PjsInBaseParent(AInMsg);;
  O := PjsOutBaseParent(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null then
    Exit;
  P := TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Parent;
  if not Assigned(P) then
    O^.Obj.Null := True
  else
  begin
    O^.Obj.Ptr := TjsPtr(NativeIntPtr(P));
    O^.Obj.Null := False;
  end;
end;

procedure TjsBaseChild.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseChild;
  O: PjsOutBaseChild;
begin
  I := PjsInBaseChild(AInMsg);;
  O := PjsOutBaseChild(AOutMsg);
  O^.Obj.Null := True;
  if I^.Self.Null or I^.Idx.Null then
    Exit;
  if I^.Obj.Null then
  // GetChild
  begin
    O^.Obj.Ptr :=
      TjsPtr(NativeIntPtr(
        TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Child[I^.Idx.Val]));
    O^.Obj.Null := False;
  end
  else
  // SetChild
  begin
    TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Child[I^.Idx.Val] :=
      TlkJSONbase(NativeIntPtr(TjsPtr(I^.Obj.Ptr)));
    O^.Obj.Ptr := I^.Obj.Ptr;
    O^.Obj.Null := False;
  end;
end;

procedure BaseValue
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseValue;
  O: PjsOutBaseValue;
  S: String;
begin
  I := PjsInBaseValue(AInMsg);;
  O := PjsOutBaseValue(AOutMsg);
  O^.SVal.Null := True;
  if I^.Self.Null then Exit;
  if I^.SVal.Null then
    S := TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value
  else
  begin
    S := String(I^.SVal.Val);
    TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value := S;
  end;
  O^.SVal.Len := Length(S);
  O^.SVal.Val := S;
  O^.SVal.Null := False;
end;

procedure TjsBaseValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseValue;
  O: PjsOutBaseValue;
  S: String;
begin
  BaseValue(AStatus, AContext, AInMsg, AOutMsg);
end;

procedure BaseWideValue
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBaseWideValue;
  O: PjsOutBaseWideValue;
  Stream: TStringStream;
begin
  I := PjsInBaseWideValue(AInMsg);
  O := PjsOutBaseWideValue(AOutMsg);
  O^.WVal.Null := True;
  if I^.Self.Null then Exit;
  try
    Stream := TStringStream.Create;
    if I^.WVal.Null then
    begin
      Stream.WriteString
        (TlkJSONbase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value);
      WriteStreamToBlob(Stream, AStatus, AContext, @(O^.WVal.Ptr));
      O^.WVal.Null := False;
    end
    else
    begin
      ReadBlobToStream(Stream, AStatus, AContext, (@I^.WVal.Ptr));
      TlkJSONstring(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value :=
        Stream.DataString;
      O^.WVal.Ptr := I^.WVal.Ptr;
      O^.WVal.Null := False;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TjsBaseWideValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
begin
  BaseWideValue(AStatus, AContext, AInMsg, AOutMsg);
end;

procedure TjsBaseSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONBase.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONBase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsBaseSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONBase.SelfTypeName else
    S := TlkJSONBase(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

procedure TjsBooleanValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBooleanValue;
  O: PjsOutBooleanValue;
  B: Boolean;
begin
  I := PjsInBooleanValue(AInMsg);;
  O := PjsOutBooleanValue(AOutMsg);
  O^.Bool.Null := True;
  if I^.Self.Null then Exit;
  if I^.Bool.Null then
    B := TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value
  else
  begin
    B := I^.Bool.Val;
    TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value := I^.Bool.Val;
  end;
  O^.Bool.Val := B;
  O^.Bool.Null := False;
end;

procedure TjsBooleanGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInBooleanGenerate;
  O: PjsObj;
begin
  I := PjsInBooleanGenerate(AInMsg);
  O := PjsObj(AOutMsg);
  if I^.Bool.Null then I^.Bool.Null := True;
  try
    if I^.Self.Null then // class function
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONboolean.Generate(I^.Bool.Val)))
    else
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate(I^.Bool.Val)));
    O^.Null := False;
  except
    O^.Null := True;
    raise;
  end;
end;

procedure TjsBooleanSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONboolean.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsBooleanSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONboolean.SelfTypeName else
    S := TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

procedure TjsNumberValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInNumberValue;
  O: PjsOutNumberValue;
  Dbl: Double;
begin
  I := PjsInNumberValue(AInMsg);;
  O := PjsOutNumberValue(AOutMsg);
  O^.Dbl.Null := True;
  if I^.Self.Null then Exit;
  if I^.Dbl.Null then
    Dbl := TlkJSONNumber(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value
  else
  begin
    Dbl := I^.Dbl.Val;
    TlkJSONNumber(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value := I^.Dbl.Val;
  end;
  O^.Dbl.Val := Dbl;
  O^.Dbl.Null := False;
end;

procedure TjsNumberGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInNumberGenerate;
  O: PjsObj;
begin
  I := PjsInNumberGenerate(AInMsg);
  O := PjsObj(AOutMsg);
  if I^.Dbl.Null then I^.Dbl.Val := 0;
  try
    if I^.Self.Null then // class function
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONnumber.Generate(I^.Dbl.Val)))
    else
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONnumber(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate(I^.Dbl.Val)));
    O^.Null := False;
  except
    O^.Null := True;
    raise;
  end;
end;

procedure TjsNumberSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONnumber.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONnumber(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsNumberSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONnumber.SelfTypeName else
    S := TlkJSONnumber(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

procedure TjsStringValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
begin
  BaseValue
    (AStatus, AContext, PjsInStringValue(AInMsg), PjsOutStringValue(AOutMsg));
end;

procedure TjsStringWideValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
begin
  BaseWideValue
    (AStatus, AContext, PjsInStringWideValue(AInMsg), PjsOutStringWideValue(AOutMsg));
end;

procedure TjsStringGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInStringGenerate;
  O: PjsObj;
begin
  I := PjsInStringGenerate(AInMsg);
  O := PjsObj(AOutMsg);
  if I^.Str.Null then I^.Str.Val := '';
  try
    if I^.Self.Null then // class function
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONstring.Generate(I^.Str.Val)))
    else
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONstring(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate(I^.Str.Val)));
    O^.Null := False;
  except
    O^.Null := True;
    raise;
  end;
end;

procedure TjsStringWideGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInStringWideGenerate;
  O: PjsObj;
  Stream: TStringStream;
  S: String;
begin
  I := PjsInStringWideGenerate(AInMsg);
  O := PjsObj(AOutMsg);
  O^.Null := True;
  if I^.WStr.Null then S:= ''
  else
  begin
    Stream := TStringStream.Create;
    try
      ReadBlobToStream(Stream, AStatus, AContext, @(I^.WStr.Ptr));
      S := Stream.DataString;
    finally
      Stream.Free;
    end;
  end;
  try
    if I^.Self.Null then // class function
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONstring.Generate(S)))
    else
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONstring(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate(S)));
    O^.Null := False;
  except
    O^.Null := True;
    raise;
  end;
end;

procedure TjsStringSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONstring.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONstring(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsStringSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONstring.SelfTypeName else
    S := TlkJSONstring(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

procedure TjsNullValue.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInNullValue;
  O: PjsOutNullValue;
begin
  I := PjsInNullValue(AInMsg);
  O := PjsOutNullValue(AOutMsg);
  O^.Res.Null := True;
  if I^.Self.Null then Exit;
  if VarIsNull(TlkJSONnull(NativeIntPtr(TjsPtr(I^.Self.Ptr))).Value) then
    O^.Res.Val := 0 else
    O^.Res.Val := 1; // error
  O^.Res.Null := False;
end;

procedure TjsNullGenerate.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInNullGenerate;
  O: PjsObj;
begin
  I := PjsInNullGenerate(AInMsg);
  O := PjsObj(AOutMsg);
  try
    if I^.Self.Null then // class function
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONnull.Generate))
    else
      O^.Ptr :=
        TjsPtr(NativeIntPtr(TlkJSONboolean(NativeIntPtr(TjsPtr(I^.Self.Ptr))).
          Generate));
    O^.Null := False;
  except
    O^.Null := True;
    raise;
  end;
end;

procedure TjsNullSelfType.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfType;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfType(AOutMsg);
  O^.SelfType.Null := True;
  if I^.Self.Null then // class function
    O^.SelfType.Val := SmallInt(TlkJSONnull.SelfType) else
    O^.SelfType.Val :=
      SmallInt(TlkJSONnull(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfType);
  O^.SelfType.Null := False;
end;

procedure TjsNullSelfTypeName.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsSelf;
  O: PjsSelfTypeName;
  S: String;
begin
  I := PjsSelf(AInMsg);
  O := PjsSelfTypeName(AOutMsg);
  O^.SelfTypeName.Null := True;
  if I^.Self.Null then // class function
    S := TlkJSONnull.SelfTypeName else
    S := TlkJSONnull(NativeIntPtr(TjsPtr(I^.Self.Ptr))).SelfTypeName;
  O^.SelfTypeName.Len := Length(S);
  O^.SelfTypeName.Val := S;
  O^.SelfTypeName.Null := False;
end;

{ TlkJSON }

procedure TjsParseText.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInParseText;
  O: PjsOutParseText;
  Stream: TStringStream;
begin
  I := PjsInParseText(AInMsg);
  if I^.Conv.Null then I^.Conv.Val := False;
  O := PjsOutParseText(AOutMsg);
  O^.Obj.Null := True;
  if not I^.Text.Null then
  begin
    Stream := TStringStream.Create;
    try
      ReadBlobToStream(Stream, AStatus, AContext, (@I^.Text.Ptr));
      O^.Obj.Ptr :=
        TjsPtr(
           NativeIntPtr(TlkJSON.ParseText(Stream.DataString, I^.Conv.Val))
          );
      O^.Obj.Null := False;
    finally
      Stream.Free;
    end;
  end;
end;

procedure TjsParseString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInParseString;
  O: PjsOutParseString;
  Stream: TStringStream;
begin
  I := PjsInParseString(AInMsg);
  if I^.Conv.Null then I^.Conv.Val := False;
  O := PjsOutParseString(AOutMsg);
  O^.Obj.Null := True;
  if not I^.Str.Null then
  begin
    Stream := TStringStream.Create;
    try
      Stream.WriteBuffer(I^.Str.Val, I^.Str.Len);
      O^.Obj.Ptr :=
        TjsPtr(
           NativeIntPtr(TlkJSON.ParseText(Stream.DataString, I^.Conv.Val))
          );
      O^.Obj.Null := False;
    finally
      Stream.Free;
    end;
  end;
end;

procedure TjsGenerateText.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInGenerateText;
  O: PjsOutGenerateText;
  Stream: TStringStream;
begin
  I := PjsInGenerateText(AInMsg);
  if I^.Conv.Null then I^.Conv.Val := False;
  O := PjsOutGenerateText(AOutMsg);
  O^.Text.Null := True;
  if not I^.Obj.Null then
  begin
    Stream := TStringStream.Create;
    try
      Stream.WriteString(
         TlkJSON.GenerateText(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Obj.Ptr))),
           I^.Conv.Val)
        );
      WriteStreamToBlob(Stream, AStatus, AContext, @(O^.Text.Ptr));
      O^.Text.Null := False;
    finally
      Stream.Free;
    end;
  end;
end;

procedure TjsGenerateString.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInGenerateString;
  O: PjsOutGenerateString;
  Stream: TStringStream;
begin
  I := PjsInGenerateString(AInMsg);
  if I^.Conv.Null then I^.Conv.Val := False;
  O := PjsOutGenerateString(AOutMsg);
  O^.Str.Null := True;
  if not I^.Obj.Null then
  begin
    Stream := TStringStream.Create;
    try
      Stream.WriteString(
         TlkJSON.GenerateText(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Obj.Ptr))),
           I^.Conv.Val)
        );
      Stream.Position := 0;
      if Stream.Size > SizeOf(O^.Str) then
        O^.Str.Len := SizeOf(O^.Str) else
        O^.Str.Len := Stream.Size;
      Stream.ReadBuffer(O^.Str.Val, O^.Str.Len);
      O^.Str.Null := False;
    finally
      Stream.Free;
    end;
  end;
end;

{ Readable }

procedure TjsReadableText.execute
  (AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  I: PjsInReadableText;
  O: PjsOutReadableText;
  Stream: TStringStream;
begin
  I := PjsInReadableText(AInMsg);
  if I^.Level.Null then I^.Level.Val := 0;
  if I^.Conv.Null then I^.Conv.Val := False;
  O := PjsOutReadableText(AOutMsg);
  O^.Text.Null := True;
  if not I^.Obj.Null then
  begin
    Stream := TStringStream.Create;
    try
      Stream.WriteString(
         GenerateReadableText(TlkJSONobject(NativeIntPtr(TjsPtr(I^.Obj.Ptr))),
           I^.Level.Val, I^.Conv.Val)
        );
      WriteStreamToBlob(Stream, AStatus, AContext, @(O^.Text.Ptr));
      O^.Text.Null := False;
    finally
      Stream.Free;
    end;
  end;
end;

end.
