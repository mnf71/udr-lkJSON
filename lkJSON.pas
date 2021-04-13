{
 *	PROGRAM: lkJSON <liblkjson.so>
 *	MODULE: lkJSON.pas
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

library lkJSON;

{$DEFINE THREADSAFE}

{$IFDEF FPC}
  {$IFDEF GENERIC}
    {$MODE OBJFPC}{$H+}
  {$ELSE}
    {$MODE DELPHI}{$H+}
  {$ENDIF}
{$ELSE}
{$ENDIF}

uses Classes, SysUtils, Firebird, udrJSON;

var
  UnloadFlag: Boolean;
  fbUnloadFlag: BooleanPtr;

function firebird_udr_plugin
  (AStatus: IStatus; AUnloadFlagLocal: BooleanPtr; AUdrPlugin: IUdrPlugin):
  BooleanPtr; cdecl;
begin
  { TlkJSONobject }

  AUdrPlugin.registerFunction(AStatus, 'ObjectNew', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectNew>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectDispose', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectDispose>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectAdd', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAdd>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectAddBoolean', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAddBoolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectAddDouble', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAddDouble>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectAddInteger', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAddInteger>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectAddString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAddString>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectAddWideString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectAddWideString>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectDelete', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectDelete>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectIndexOfName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectIndexOfName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectIndexOfObject', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectIndexOfObject>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectField', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectField>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectSelfTypeName>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectFieldByIndex', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectFieldByIndex>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectNameOf', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectNameOf>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectGetBoolean', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetBoolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetDouble', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetDouble>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetInteger', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetInteger>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetString>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetWideString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetWideString>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectGetBooleanByName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetBooleanByName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetDoubleByName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetDoubleByName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetIntegerByName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetIntegerByName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetStringByName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetStringByName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetWideStringByName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectGetWideStringByName>.Create);

  { TlkJSONobjectmethod }

  AUdrPlugin.registerFunction(AStatus, 'ObjectMethodObjValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectMethodObjValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectMethodName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectMethodName>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectMethodGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsObjectMethodGenerate>.Create);

  { TlkJSONlist }

  AUdrPlugin.registerFunction(AStatus, 'ListAdd', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAdd>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListAddBoolean', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAddBoolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListAddDouble', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAddDouble>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListAddInteger', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAddInteger>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListAddString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAddString>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListAddWideString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListAddWideString>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ListDelete', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListDelete>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListIndexOfObject', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListIndexOfObject>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ListGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ListSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsListSelfTypeName>.Create);

  { TlkJSONcustomlist }

  AUdrPlugin.registerFunction(AStatus, 'CustomListGetBoolean', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsCustomListGetBoolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'CustomListGetDouble', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsCustomListGetDouble>.Create);
  AUdrPlugin.registerFunction(AStatus, 'CustomListGetInteger', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsCustomListGetInteger>.Create);
  AUdrPlugin.registerFunction(AStatus, 'CustomListGetString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsCustomListGetString>.Create);
  AUdrPlugin.registerFunction(AStatus, 'CustomListGetWideString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsCustomListGetWideString>.Create);

  { TlkJSONbase }

  AUdrPlugin.registerFunction(AStatus, 'BaseDispose', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseDispose>.Create);

  AUdrPlugin.registerFunction(AStatus, 'BaseField', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseField>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseCount', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseCount>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseChild', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseChild>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseWideValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseWideValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BaseSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBaseSelfTypeName>.Create);

  AUdrPlugin.registerFunction(AStatus, 'BooleanValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBooleanValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BooleanGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBooleanGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BooleanSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBooleanSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'BooleanSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsBooleanSelfTypeName>.Create);

  AUdrPlugin.registerFunction(AStatus, 'NumberValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNumberValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NumberGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNumberGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NumberSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNumberSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NumberSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNumberSelfTypeName>.Create);

  AUdrPlugin.registerFunction(AStatus, 'StringValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StringWideValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringWideValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StringGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StringWideGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringWideGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StringSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StringSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsStringSelfTypeName>.Create);

  AUdrPlugin.registerFunction(AStatus, 'NullValue', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNullValue>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NullGenerate', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNullGenerate>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NullSelfType', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNullSelfType>.Create);
  AUdrPlugin.registerFunction(AStatus, 'NullSelfTypeName', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsNullSelfTypeName>.Create);

  { TlkJSON }
  AUdrPlugin.registerFunction(AStatus, 'ParseText', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsParseText>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ParseString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsParseString>.Create);
  AUdrPlugin.registerFunction(AStatus, 'GenerateText', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsGenerateText>.Create);
  AUdrPlugin.registerFunction(AStatus, 'GenerateString', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsGenerateString>.Create);

  { ... }
  AUdrPlugin.registerFunction(AStatus, 'ReadableText', {$IFNDEF GENERIC}{$ELSE}specialize{$ENDIF} TjsFunctionFactory<TjsReadableText>.Create);

  fbUnloadFlag := AUnloadFlagLocal;
  Result := @UnloadFlag;
end;

exports
  firebird_udr_plugin;

initialization

  UnloadFlag := False;

finalization

  if ((fbUnloadFlag <> Nil) and not UnloadFlag) then
    fbUnloadFlag^ := True;

end.



