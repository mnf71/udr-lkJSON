{
  LkJSON v1.07+

  23 november 2020

* Copyright (c) 2006,2007,2008,2009 Leonid Koninin
* leon_kon@users.sourceforge.net
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Leonid Koninin ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Leonid Koninin BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  changes:

  v1.07 23/11/2020 * changed lkJSON source code for Firebird UDR-engine
                   + enabled Conv params for disable UTF8 conversion
                   + added NULL_SQL directive for PSQL integration
                   * other improve & fix
  v1.07 06/11/2009 * fixed a bug in js_string - thanks to Andrew G. Khodotov
                   * fixed error with Double-slashes - thanks to anonymous user
                   * fixed a BOM bug in parser, thanks to jasper_dale
  v1.06 13/03/2009 * fixed a bug in string parsing routine
                   * looked routine from the Adrian M. Jones, and get some
                     ideas from it; thanks a lot, Adrian!
                   * checked error reported by phpop and fix it in the string
                     routine; also, thanks for advice.
  v1.05 26/01/2009 + added port to D2009 by Daniele Teti, thanx a lot! really,
                     i haven'T^ the 2009 version, so i can'T^ play with it. I was
                     add USE_D2009 directive below, disabled by default
                   * fixed two small bugs in parsing object: errors with empty
                     object and list; thanx to RSDN's delphi forum members
                   * fixed "[2229135] Value deletion is broken" tracker
                     issue, thanx to anonymous sender provided code for
                     tree version
                   * fixed js_string according to "[1917047] (much) faster
                     js_string Parse" tracker issue by Joao Inacio; a lot of
                     thanx, great speedup!
  v1.04 05/04/2008 + a declaration of Field property moved from TlkJSONobject
                     to TlkJSONbase; thanx for idea to Andrey Lukyanov; this
                     improve objects use, look the bottom of SAMPLE2.DPR
                   * fixed field name in TlkJSONobject to WideString
  v1.03 14/03/2008 + added a code for generating readable JSON text, sended to
                     me by Kusnassriyanto Saiful Bahri, thanx to him!
                   * from this version, library distributed with BSD
                     license, more pleasure for commercial programmers :)
                   * was rewritten internal storing of objects, repacing
                     hash tables with balanced trees (AA tree, by classic
                     author's Variant). On mine machine, with enabled fastmm,
                     tree Variant is about 30% slower in from-zero creation,
                     but about 50% faster in parsing; also deletion of
                     objects will be much faster than a hash-one.
                     Hashes (old-style) can be switched on by enabling
                     USE_HASH directive below
  v1.02 14/09/2007 * fix mistypes in diffrent places; thanx for reports
                     to Aleksandr Fedorov and Tobias Wrede
  v1.01 18/05/2007 * fix small bug in new text generation routine, check
                     library for leaks by fastmm4; thanx for idea and comments
                     for Glynn Owen
  v1.00 12/05/2007 * some fixes in new code (mistypes, mistypes...)
                   * also many fixes by ideas of Henri Gourvest - big thanx
                     for him again; he send me code for thread-safe initializing
                     of hash table, some FPC-compatible issues (not tested by
                     mySelf) and better code for localization in latest
                     delphi versions; very, very big thanx!
                   * rewritten procedure of json text generating, with wich
                     work of it speeds up 4-5 times (on test) its good for
                     a large objects
                   * started a large work for making source code Self-doc
                     (not autodoc!)
  v0.99 10/05/2007 + add functions to list and object:
                      function getInt(Idx: Integer): Integer;
                      function getString(Idx: Integer): String;
                      function getWideString(Idx: Integer):WideString;
                      function getDouble(Idx: Integer): Double;
                      function getBoolean(Idx: Integer): Boolean;
                   + add overloaded functions to object:
                      function getDouble(nm: String): Double; overload;
                      function getInt(nm: String): Integer; overload;
                      function getString(nm: String): String; overload;
                      function getWideString(nm: String): WideString; overload;
                      function getBoolean(nm: String): Boolean; overload;
                   * changed storing mech of TlkJSONcustomlist descendants from
                     dynamic array to TList; this gives us great speedup with
                     lesser changes; thanx for idea to Henri Gourvest
                   * also reworked hashtable to work with TList, so it also
                     increase speed of work
  v0.98 09/05/2007 * fix small bug in work with WideStrings(UTF8), thanx to
                     IVO GELOV to description and sources
  v0.97 10/04/2007 + add capabilities to work with KOL delphi projects; for
                     this will define KOL variable in begin of text; of course,
                     in this case object TlkJSONstreamed is not compiled.
  v0.96 03/30/2007 + add TlkJSONFuncEnum and method ForEach in all
                     TlkJSONcustomlist descendants
                   + add property UseHash(r/o) to TlkJSONobject, and parameter
                     UseHash:Boolean to object constructors; set it to false
                     allow to disable using of hash-table, what can increase
                     speed of work in case of objects with low number of
                     methods(fields); [by default it is True]
                   + added conditional compile directive DOTNET for use in .Net
                     based delphi versions; remove dot in declaration below
                     (thanx for idea and sample code to Tim Radford)
                   + added property HashOf to TlkHashTable to allow use of
                     users hash functions; on enter is widestring, on exit is
                     Cardinal (32 bit unsigned). Original HashOf renamed to
                     DefaultHashOf
                   * hash table object of TlkJSONobject wrapped by property called
                     HashTable
                   * fixed some minor bugs
  v0.95 03/29/2007 + add object TlkJSONstreamed what descendant of TlkJSON and
                     able to load/save JSON objects from/to streams/files.
                   * fixed small bug in generating of unicode strings representation
  v0.94 03/27/2007 + add properties NameOf and FieldByIndex to TlkJSONobject
                   * fix small error in parsing unicode chars
                   * small changes in hashing code (try to speed up)
  v0.93 03/05/2007 + add overloaded functions to list and object
                   + add enum type TlkJSONtypes
                   + add functions: SelfType:TlkJSONtypes and
                     SelfTypeName: String to every TlkJSONbase child
                   * fix mistype 'IndefOfName' to 'IndexOfName'
                   * fix mistype 'IndefOfObject' to 'IndexOfObject'
  v0.92 03/02/2007 + add some fix to TlkJSON.ParseText to fix bug with parsing
                     objects - object methods not always added properly
                     to hash array (thanx to Chris Matheson)
  ...
}

unit uLkJSON;

{$IFDEF FPC}
  {$MODE OBJFPC}
  {.$DEFINE HAVE_FORMATSETTING}
  {$H+}
{$ELSE}
  {$IF RTLVersion > 14.00}
    {$DEFINE HAVE_FORMATSETTING}
    {$IF RTLVersion > 19.00}                            null Value
      {$DEFINE USE_D2009}
    {$IFEND}
    {$H+}
  {$IFEND}
  {.$DEFINE DOTNET}
{$ENDIF}

interface

{$DEFINE NEW_STYLE_GENERATE}
{.$DEFINE USE_HASH}
{.$DEFINE TCB_EXT}
{.$DEFINE STREAM}

uses Classes, SysUtils, Variants;

type
  TlkJSONtypes =
    (jsBase, jsNumber, jsString, jsBoolean, jsNull, jsList, jsObject);

{$IFDEF DOTNET}
  TlkJSONdotnetclass = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure AfterConstruction; virtual;
    procedure BeforeDestruction; virtual;
  end;
{$ENDIF DOTNET}

  TlkJSONbase = class{$IFDEF DOTNET}(TlkJSONdotnetclass){$ENDIF}
  protected
    function GetValue: Variant; virtual;
    procedure SetValue(const AValue: Variant); virtual;
    function GetChild(Idx: Integer): TlkJSONbase; virtual;
    procedure SetChild(Idx: Integer; const AValue: TlkJSONbase);
      virtual;
    function GetCount: Integer; virtual;
    function GetField(aName: Variant):TlkJSONbase; virtual;
  public
{ исправлено
    property Field[aName: Variant]: TlkJSONbase read GetField;
}
    property Field[aName: Variant]: TlkJSONbase read GetField; default;
    property Count: Integer read GetCount;
    property Child[Idx: Integer]: TlkJSONbase read GetChild write SetChild;
    property Value: Variant read GetValue write SetValue;
    class function SelfType: TlkJSONtypes; virtual;
    class function SelfTypeName: String; virtual;
  end;

  TlkJSONnumber = class(TlkJSONbase)
  protected
    FValue: Extended;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: Extended = 0): TlkJSONnumber;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;
  end;

  TlkJSONstring = class(TlkJSONbase)
  protected
    FValue: WideString;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(const wsValue: WideString = ''):
      TlkJSONstring;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;
  end;

  TlkJSONboolean = class(TlkJSONbase)
  protected
    FValue: Boolean;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: Boolean = True): TlkJSONboolean;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;
  end;

  TlkJSONnull = class(TlkJSONbase)
  protected
    function GetValue: Variant; override;
{ -
    function Generate: TlkJSONnull;
}
  public
{ + }
    class function Generate: TlkJSONnull;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;
  end;

  TlkJSONFuncEnum = procedure
    (ElName: String; Elem: TlkJSONbase; Data: Pointer; var Continue: Boolean)
    of object;

  TlkJSONcustomlist = class(TlkJSONbase)
  protected
{
    FValue: array of TlkJSONbase;
}
    fList: TList;
    function GetCount: Integer; override;
    function GetChild(Idx: Integer): TlkJSONbase; override;
    procedure SetChild(Idx: Integer; const AValue: TlkJSONbase);
      override;
    function ForEachElement(Idx: Integer; var nm: String):
      TlkJSONbase; virtual;

    function GetField(aName: Variant):TlkJSONbase; override;

    function _Add(Obj: TlkJSONbase): Integer; virtual;
    procedure _Delete(iIndex: Integer); virtual;
    function _IndexOf(Obj: TlkJSONbase): Integer; virtual;
  public
    procedure ForEach(fnCallBack: TlkJSONFuncEnum; pUserData:
      pointer);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function getInt(Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer; virtual;
    function getString(Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String; virtual;
    function getWideString(Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString; virtual;
    function getDouble(Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double; virtual;
    function getBoolean(Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean; virtual;
  end;

  TlkJSONlist = class(TlkJSONcustomlist)
  protected
  public
    function Add(Obj: TlkJSONbase): Integer; overload;

    function Add(bool: Boolean): Integer; overload;
    function Add(nmb: Double): Integer; overload;
    function Add(s: String): Integer; overload;
    function Add(const ws: WideString): Integer; overload;
    function Add(inmb: Integer): Integer; overload;

    procedure Delete(Idx: Integer);
    function IndexOf(Obj: TlkJSONbase): Integer;

    class function Generate: TlkJSONlist;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;
  end;

  TlkJSONobjectmethod = class(TlkJSONbase)
  protected
    FValue: TlkJSONbase;
    FName: WideString;
    procedure SetName(const AValue: WideString);
  public
    property ObjValue: TlkJSONbase read FValue;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Name: WideString read FName write SetName;
    class function Generate(const aName: WideString; aobj: TlkJSONbase):
      TlkJSONobjectmethod;
  end;

{$IFDEF USE_HASH}
  PlkHashItem = ^TlkHashItem;
  TlkHashItem = packed record
    hash: Cardinal;
    index: Integer;
  end;

  TlkHashFunction = function(const ws: WideString): Cardinal of
    object;

  TlkHashTable = class
  private
    FParent: TObject; // TCB: parent for check chaining op.
    FHashFunction: TlkHashFunction;
    procedure SetHashFunction(const AValue: TlkHashFunction);
  protected
    a_x: array[0..255] of TList;
    procedure hswap(j, k, l: Integer);
    function InTable(const ws: WideString; var i, j, k: Cardinal):
      Boolean;
  public
    function counters: String;

    function DefaultHashOf(const ws: WideString): Cardinal;
    function SimpleHashOf(const ws: WideString): Cardinal;

    property HashOf: TlkHashFunction read FHashFunction write
      SetHashFunction;

    function IndexOf(const ws: WideString): Integer;

    procedure AddPair(const ws: WideString; Idx: Integer);
    procedure Delete(const ws: WideString);

    constructor Create;
    destructor Destroy; override;
  end;
{$ELSE}
{
  Implementation based on "Arne Andersson, Balanced Search Trees Made Simpler"
}
  PlkBalNode = ^TlkBalNode;
  TlkBalNode = packed record
    Left,
    Right: PlkBalNode;
    Level: Byte;
    Key: Integer;
    nm: WideString;
  end;

  TlkBalTree = class
  protected
    fDeleted, fLast, fBottom, fRoot: PlkBalNode;
    procedure Skew(var T: PlkBalNode);
    procedure Split(var T: PlkBalNode);
  public
    procedure Clear;

    function Counters: String;

    function Insert(const ws: WideString; X: Integer): Boolean;
    function Delete(const ws: WideString): Boolean;

    function IndexOf(const ws: WideString): Integer;

    constructor Create;
    destructor Destroy; override;
  end;
{$ENDIF USE_HASH}

  TlkJSONobject = class(TlkJSONcustomlist)
  protected
{$IFDEF USE_HASH}
    ht: TlkHashTable;
{$ELSE}
    ht: TlkBalTree;
{$ENDIF USE_HASH}
    FUseHash: Boolean;
    function GetFieldByIndex(Idx: Integer): TlkJSONbase;
    function GetNameOf(Idx: Integer): WideString;
    procedure SetFieldByIndex(Idx: Integer; const AValue: TlkJSONbase);
{$IFDEF USE_HASH}
    function GetHashTable: TlkHashTable;
{$ELSE}
    function GetHashTable: TlkBalTree;
{$ENDIF USE_HASH}
    function ForEachElement(Idx: Integer; var nm: String): TlkJSONbase;
      override;
    function GetField(aName: Variant):TlkJSONbase; override;
  public
    property UseHash: Boolean read FUseHash;
{$IFDEF USE_HASH}
    property HashTable: TlkHashTable read GetHashTable;
{$ELSE}
    property HashTable: TlkBalTree read GetHashTable;
{$ENDIF USE_HASH}

    constructor Create(bUseHash: Boolean = True);
    destructor Destroy; override;

    function Add(const aName: WideString; aobj: TlkJSONbase): Integer;
      overload;

    function OldGetField(nm: WideString): TlkJSONbase;
    procedure OldSetField(nm: WideString; const AValue: TlkJSONbase);

    function Add(const aName: WideString; bool: Boolean): Integer; overload;
    function Add(const aName: WideString; nmb: Double): Integer; overload;
    function Add(const aName: WideString; inmb: Integer): Integer; overload;
    function Add(const aName: WideString; s: String): Integer; overload;
    function Add(const aName: WideString; const ws: WideString): Integer;
      overload;

    procedure Delete(Idx: Integer);
    function IndexOfName(const aName: WideString): Integer;
    function IndexOfObject(aobj: TlkJSONbase): Integer;
    property Field[nm: WideString]: TlkJSONbase read OldGetField
      write OldSetField; default;

    class function Generate(AUseHash: Boolean = True): TlkJSONobject;
    class function SelfType: TlkJSONtypes; override;
    class function SelfTypeName: String; override;

    property FieldByIndex[Idx: Integer]:
      TlkJSONbase read GetFieldByIndex write SetFieldByIndex;
    property NameOf[Idx: Integer]: WideString read GetNameOf;

    function getBoolean
      (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean; overload; override;
    function getDouble
      (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double; overload; override;
    function getInt
      (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer; overload; override;
    function getString
      (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String; overload; override;
    function getWideString
      (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString; overload; override;

    function {$IFDEF TCB_EXT}getBooleanFromName{$ELSE}getBoolean{$ENDIF}
      (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean; overload;
    function {$IFDEF TCB_EXT}getDoubleFromName{$ELSE}getDouble{$ENDIF}
      (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double; overload;
    function {$IFDEF TCB_EXT}getIntFromName{$ELSE}getInt{$ENDIF}
      (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer; overload;
    function {$IFDEF TCB_EXT}getStringFromName{$ELSE}getString{$ENDIF}
      (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String; overload;
    function {$IFDEF TCB_EXT}getWideStringFromName{$ELSE}getWideString{$ENDIF}
      (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString; overload;
  end;
  PlkJSONobject = ^TlkJSONobject;

  TlkJSON = class
  public
{ исправлено
    class function ParseText(const Txt: String): TlkJSONbase;
    class function GenerateText(Obj: TlkJSONbase): String;
}
    class function ParseText(const Txt: String; Conv: Boolean = False): TlkJSONbase;
    class function GenerateText(Obj: TlkJSONbase; Conv: Boolean = False): String;
  end;
  PlkJSON = ^TlkJSON;

{$IFDEF STREAM}
  TlkJSONstreamed = class(TlkJSON)
{ исправлено
    class function LoadFromStream(Src: TStream): TlkJSONbase;
    class procedure SaveToStream(Obj: TlkJSONbase; dst: TStream);
    class function LoadFromFile(SrcName: String): TlkJSONbase;
    class procedure SaveToFile(Obj: TlkJSONbase; DstName: String);
}
    class function LoadFromStream(Src: TStream; Conv: Boolean = False): TlkJSONbase;
    class procedure SaveToStream(Obj: TlkJSONbase; Dst: TStream; conv: Boolean = False);
    class function LoadFromFile(SrcName: String; Conv: Boolean = False): TlkJSONbase;
    class procedure SaveToFile(Obj: TlkJSONbase; DstName: String; conv: Boolean = False);
  end;
{$ENDIF STREAM}

{ исправлено
function GenerateReadableText(vObj: TlkJSONbase; var vLevel:
  Integer): String;
}
function GenerateReadableText
  (vObj: TlkJSONbase; var vLevel: Integer; conv: Boolean = False;
   nested: Boolean = False
  ): String;

implementation

uses { исправлено Math, } StrUtils;

type
  ElkIntException = class(Exception)
  protected
    Idx: Integer;
  public
    constructor Create(AIdx: Integer; AMsg: String);
end;

// author of next two functions is Kusnassriyanto Saiful Bahri

function Indent(vTab: Integer): String;
begin
  Result := DupeString('  ', vTab);
end;

{ исправлено
function GenerateReadableText(vObj: TlkJSONbase; var vLevel:
  Integer): String;
}
function GenerateReadableText
  (vObj: TlkJSONbase; var vLevel: Integer; conv: Boolean = False;
   nested: Boolean = False
  ): String;
var
  i: Integer;
  vStr: String;
  xs: TlkJSONstring;
begin
  vLevel := vLevel + 1;
  if vObj is TlkJSONObject then
    begin
      vStr := '';
      for i := 0 to TlkJSONobject(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
{ исправлено
            GenerateReadableText(TlkJSONobject(vObj).Child[i], vLevel);
}
            GenerateReadableText(TlkJSONobject(vObj).Child[i], vLevel, conv, True);
        end;
      if vStr <> '' then
        begin
          vStr := '{'#13#10 + vStr + #13#10 + Indent(vLevel - 1) + '}';
        end
      else
        begin
          vStr := '{}';
        end;
      if not nested then
        vStr := Indent(vLevel - 1) + vStr;
      Result := vStr;
    end
  else if vObj is TlkJSONList then
    begin
      vStr := '';
      for i := 0 to TlkJSONList(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
{ исправлено
            GenerateReadableText(TlkJSONList(vObj).Child[i], vLevel);
}
            GenerateReadableText(TlkJSONList(vObj).Child[i], vLevel, conv, True);
        end;
      if vStr <> '' then
        begin
          vStr := '['#13#10 + vStr + #13#10 + Indent(vLevel - 1) + ']';
        end
      else
        begin
          vStr := '[]';
        end;
      if not nested then
        vStr := Indent(vLevel - 1) + vStr;
      Result := vStr;
    end
  else if vObj is TlkJSONobjectmethod then
    begin
      vStr := '';
      xs := TlkJSONstring.Create;
      try
        xs.Value := TlkJSONobjectMethod(vObj).Name;
{ исправлено
        vStr := GenerateReadableText(xs, vLevel);
}
        vStr := GenerateReadableText(xs, vLevel, conv, True);
        vLevel := vLevel - 1;
{ исправлено
        vStr := vStr + ':' + GenerateReadableText(TlkJSONbase(TlkJSONobjectmethod(vObj).ObjValue), vLevel);
}
        vStr := vStr + ':' + GenerateReadableText(TlkJSONbase(TlkJSONobjectmethod(vObj).ObjValue), vLevel, Conv, True);
        vLevel := vLevel + 1;
        Result := vStr;
      finally
        xs.Free;
      end;
    end
  else
    begin
      if vObj is TlkJSONobjectmethod then
        begin
          if TlkJSONobjectMethod(vObj).Name <> '' then
            begin
            end;
        end;
{ исправлено
      Result := TlkJSON.GenerateText(vObj);
}
      Result := TlkJSON.GenerateText(vObj, conv);
    end;
  vLevel := vLevel - 1;
end;

// author of this routine is IVO GELOV

function Code2UTF(iNumber: Integer): UTF8String;
begin
  Result := '';
  if iNumber < 128 then Result := Chr(iNumber)
  else if iNumber < 2048 then
    Result := Chr((iNumber shr 6) + 192) + Chr((iNumber and 63) + 128)
  else if iNumber < 65536 then
    Result := Chr((iNumber shr 12) + 224) + Chr(((iNumber shr 6) and
      63) + 128) + Chr((iNumber and 63) + 128)
  else if iNumber < 2097152 then
    Result := Chr((iNumber shr 18) + 240) + Chr(((iNumber shr 12) and
      63) + 128) + Chr(((iNumber shr 6) and 63) + 128) +
      Chr((iNumber and 63) + 128);
end;

{ TlkJSONbase }

function TlkJSONbase.GetChild(Idx: Integer): TlkJSONbase;
begin
  Result := Nil;
end;

function TlkJSONbase.GetCount: Integer;
begin
  Result := 0;
end;

function TlkJSONbase.GetField(aName: Variant):TlkJSONbase;
begin
  Result := Self;
end;

function TlkJSONbase.GetValue: Variant;
begin
  Result := Variants.Null;
end;

class function TlkJSONbase.SelfType: TlkJSONtypes;
begin
  Result := jsBase;
end;

class function TlkJSONbase.SelfTypeName: String;
begin
  Result := 'jsBase';
end;

procedure TlkJSONbase.SetChild(Idx: Integer; const AValue:
  TlkJSONbase);
begin

end;

procedure TlkJSONbase.SetValue(const AValue: Variant);
begin

end;

{ TlkJSONnumber }

procedure TlkJSONnumber.AfterConstruction;
begin
  inherited;
  FValue := 0;
end;

class function TlkJSONnumber.Generate(AValue: Extended):
  TlkJSONnumber;
begin
  Result := TlkJSONnumber.Create;
  Result.FValue := AValue;
end;

function TlkJSONnumber.GetValue: Variant;
begin
  Result := FValue;
end;

class function TlkJSONnumber.SelfType: TlkJSONtypes;
begin
  Result := jsNumber;
end;

class function TlkJSONnumber.SelfTypeName: String;
begin
  Result := 'jsNumber';
end;

procedure TlkJSONnumber.SetValue(const AValue: Variant);
begin
  FValue := VarAsType(AValue, varDouble);
end;

{ TlkJSONstring }

procedure TlkJSONstring.AfterConstruction;
begin
  inherited;
  FValue := '';
end;

class function TlkJSONstring.Generate(const wsValue: WideString):
  TlkJSONstring;
begin
  Result := TlkJSONstring.Create;
  Result.FValue := wsValue;
end;

function TlkJSONstring.GetValue: Variant;
begin
  Result := FValue;
end;

class function TlkJSONstring.SelfType: TlkJSONtypes;
begin
  Result := jsString;
end;

class function TlkJSONstring.SelfTypeName: String;
begin
  Result := 'jsString';
end;

procedure TlkJSONstring.SetValue(const AValue: Variant);
begin
  FValue := VarToWideStr(AValue);
end;

{ TlkJSONboolean }

procedure TlkJSONboolean.AfterConstruction;
begin
  FValue := False;
end;

class function TlkJSONboolean.Generate(AValue: Boolean):
  TlkJSONboolean;
begin
  Result := TlkJSONboolean.Create;
  Result.Value := AValue;
end;

function TlkJSONboolean.GetValue: Variant;
begin
  Result := FValue;
end;

class function TlkJSONboolean.SelfType: TlkJSONtypes;
begin
  Result := jsBoolean;
end;

class function TlkJSONboolean.SelfTypeName: String;
begin
  Result := 'jsBoolean';
end;

procedure TlkJSONboolean.SetValue(const AValue: Variant);
begin
  FValue := boolean(AValue);
end;

{ TlkJSONnull }

class function TlkJSONnull.Generate: TlkJSONnull;
begin
  Result := TlkJSONnull.Create;
end;

function TlkJSONnull.GetValue: Variant;
begin
  Result := Variants.Null;
end;

class function TlkJSONnull.SelfType: TlkJSONtypes;
begin
  Result := jsNull;
end;

class function TlkJSONnull.SelfTypeName: String;
begin
  Result := 'jsNull';
end;

{ TlkJSONcustomlist }

function TlkJSONcustomlist._Add(Obj: TlkJSONbase): Integer;
begin
  if not Assigned(Obj) then
    begin
      Result := -1;
      Exit;
    end;
  Result := fList.Add(Obj);
end;

procedure TlkJSONcustomlist.AfterConstruction;
begin
  inherited;
  fList := TList.Create;
end;

procedure TlkJSONcustomlist.BeforeDestruction;
var
  i: Integer;
begin
  for i := (Count - 1) downto 0 do _Delete(i);
  fList.Free;
  inherited;
end;

// renamed

procedure TlkJSONcustomlist._Delete(iIndex: Integer);
var
  Idx: Integer;
begin
  if not ((iIndex < 0) or (iIndex >= Count)) then
    begin
      if fList.Items[iIndex] <> nil then
        TlkJSONbase(fList.Items[iIndex]).Free;
      Idx := Pred(fList.Count);
      if iIndex<idx then
        begin
          fList.Items[iIndex] := fList.Items[Idx];
          fList.Delete(Idx);
        end
      else
        begin
          fList.Delete(iIndex);
        end;
    end;
end;

function TlkJSONcustomlist.GetChild(Idx: Integer): TlkJSONbase;
begin
  if (Idx < 0) or (Idx >= Count) then
    begin
      Result := Nil;
    end
  else
    begin
{ исправлено
      Result := fList.Items[Idx];
}
      Result := TlkJSONbase(fList.Items[Idx]);
    end;
end;

function TlkJSONcustomlist.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TlkJSONcustomlist._IndexOf(Obj: TlkJSONbase): Integer;
begin
  Result := fList.IndexOf(Obj);
end;

procedure TlkJSONcustomlist.SetChild(Idx: Integer; const AValue:
  TlkJSONbase);
begin
  if not ((Idx < 0) or (Idx >= Count)) then
    begin
      if fList.Items[Idx] <> Nil then
        TlkJSONbase(fList.Items[Idx]).Free;
      fList.Items[Idx] := AValue;
    end;
end;

procedure TlkJSONcustomlist.ForEach
  (fnCallBack: TlkJSONFuncEnum; pUserData: Pointer);
var
  iCount: Integer;
  IsContinue: Boolean;
  anJSON: TlkJSONbase;
  wsObject: String = '';
begin
  if not Assigned(fnCallBack) then Exit;
  IsContinue := True;
  for iCount := 0 to GetCount - 1 do
    begin
      anJSON := ForEachElement(iCount, wsObject);
      if Assigned(anJSON) then
        fnCallBack(wsObject, anJSON, pUserData, IsContinue);
      if not IsContinue then
        break;
    end;
end;

///---- renamed to here

function TlkJSONcustomlist.GetField(aName: Variant):TlkJSONbase;
var
  index: Integer;
begin
  if VarIsNumeric(aName) then
    begin
      index := Integer(aName);
      Result := GetChild(index);
    end
  else
    begin
      Result := inherited GetField(aName);
    end;
end;

function TlkJSONcustomlist.ForEachElement(Idx: Integer; var nm:
  string): TlkJSONbase;
begin
  nm := inttostr(Idx);
  Result := GetChild(Idx);
end;

function TlkJSONcustomlist.getDouble
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double;
var
  jn: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONnumber{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jn := Child[Idx] as TlkJSONbase;
  if not Assigned(jn) or (jn.SelfType = jsNull) then
  begin
    Result := 0;
    Null := True;
  end
  else
  begin
    Result := TlkJSONnumber(jn).Value;
    Null := False;
  end;
{$ELSE}
  jn := Child[Idx] as TlkJSONnumber;
  if not Assigned(jn) then Result := 0
  else Result := jn.Value;
{$ENDIF}
end;

function TlkJSONcustomlist.getInt
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer;
var
  jn: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONnumber{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jn := Child[Idx] as TlkJSONbase;
  if not Assigned(jn) or (jn.SelfType = jsNull) then
  begin
    Result := 0;
    Null := True;
  end
  else
  begin
    Result := Round(Int(TlkJSONnumber(jn).Value));
    Null := False;
  end;
{$ELSE}
  jn := Child[Idx] as TlkJSONnumber;
  if not Assigned(jn) then Result := 0
  else Result := Round(Int(jn.Value));
{$ENDIF}
end;

function TlkJSONcustomlist.getString
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String;
var
  js: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONstring{$ENDIF};
begin
{$IFDEF NULL_SQL}
  js := Child[Idx] as TlkJSONbase;
  if not Assigned(js) or (js.SelfType = jsNull) then
  begin
    Result := '';
    Null := True;
  end
  else
  begin
    Result := VarToStr(TlkJSONstring(js).Value);
    Null := False;
  end;
{$ELSE}
  js := Child[Idx] as TlkJSONstring;
  if not Assigned(js) then Result := ''
  else Result := VarToStr(js.Value);
{$ENDIF}
end;

function TlkJSONcustomlist.getWideString
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString;
var
  js: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONstring{$ENDIF};
begin
{$IFDEF NULL_SQL}
  js := Child[Idx] as TlkJSONbase;
  if not Assigned(js) or (js.SelfType = jsNull) then
  begin
    Result := '';
    Null := True;
  end
  else
  begin
    Result := VarToWideStr(TlkJSONstring(js).Value);
    Null := False;
  end;
{$ELSE}
  js := Child[Idx] as TlkJSONstring;
  if not Assigned(js) then Result := ''
  else Result := VarToWideStr(js.Value);
{$ENDIF}
end;

function TlkJSONcustomlist.getBoolean
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean;
var
  jb: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONboolean{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jb := Child[Idx] as TlkJSONbase;
  if not Assigned(jb) or (jb.SelfType = jsNull) then
  begin
    Result := False;
    Null := True;
  end
  else
  begin
    Result := TlkJSONboolean(jb).Value;
    Null := False;
  end;
{$ELSE}
  jb := Child[Idx] as TlkJSONboolean;
  if not Assigned(jb) then Result := False
  else Result := jb.Value;
{$ENDIF}
end;

{ TlkJSONobjectmethod }

procedure TlkJSONobjectmethod.AfterConstruction;
begin
  inherited;
  FValue := Nil;
  FName := '';
end;

procedure TlkJSONobjectmethod.BeforeDestruction;
begin
  FName := '';
  if FValue <> Nil then
    begin
      FValue.Free;
      FValue := Nil;
    end;
  inherited;
end;

class function TlkJSONobjectmethod.Generate(const aName: WideString;
  aobj: TlkJSONbase): TlkJSONobjectmethod;
begin
  Result := TlkJSONobjectmethod.Create;
  Result.FName := aName;
  Result.FValue := aobj;
end;

procedure TlkJSONobjectmethod.SetName(const AValue: WideString);
begin
  FName := AValue;
end;

{ TlkJSONlist }

function TlkJSONlist.Add(Obj: TlkJSONbase): Integer;
begin
  Result := _Add(Obj);
end;

function TlkJSONlist.Add(nmb: Double): Integer;
begin
  Result := Self.Add(TlkJSONnumber.Generate(nmb));
end;

function TlkJSONlist.Add(bool: Boolean): Integer;
begin
  Result := Self.Add(TlkJSONboolean.Generate(bool));
end;

function TlkJSONlist.Add(inmb: Integer): Integer;
begin
  Result := Self.Add(TlkJSONnumber.Generate(inmb));
end;

function TlkJSONlist.Add(const ws: WideString): Integer;
begin
  Result := Self.Add(TlkJSONstring.Generate(ws));
end;

function TlkJSONlist.Add(s: String): Integer;
begin
  Result := Self.Add(TlkJSONstring.Generate(WideString(s)));
end;

procedure TlkJSONlist.Delete(Idx: Integer);
begin
  _Delete(Idx);
end;

class function TlkJSONlist.Generate: TlkJSONlist;
begin
  Result := TlkJSONlist.Create;
end;

function TlkJSONlist.IndexOf(Obj: TlkJSONbase): Integer;
begin
  Result := _IndexOf(Obj);
end;

class function TlkJSONlist.SelfType: TlkJSONtypes;
begin
  Result := jsList;
end;

class function TlkJSONlist.SelfTypeName: String;
begin
  Result := 'jsList';
end;

{ TlkJSONobject }

function TlkJSONobject.Add(const aName: WideString; aobj:
  TlkJSONbase):
  Integer;
var
  mth: TlkJSONobjectmethod;
begin
  if not Assigned(aobj) then
    begin
      Result := -1;
      Exit;
    end;
  mth := TlkJSONobjectmethod.Create;
  mth.FName := aName;
  mth.FValue := aobj;
  Result := Self._Add(mth);
  if FUseHash then
{$IFDEF USE_HASH}
    ht.AddPair(aName, Result);
{$ELSE}
    ht.Insert(aName, Result);
{$ENDIF USE_HASH}
end;

procedure TlkJSONobject.Delete(Idx: Integer);
var
// исправлно i, j, k: Cardinal;
  mth: TlkJSONobjectmethod;
begin
  if (Idx >= 0) and (Idx < Count) then
    begin
{
      mth := FValue[Idx] as TlkJSONobjectmethod;
}
      mth := TlkJSONobjectmethod(fList.Items[Idx]);
      if FUseHash then
        begin
          ht.Delete(mth.FName);
        end;
    end;
  _Delete(Idx);
{$IFDEF USE_HASH}
  if (Idx < Count) and (FUseHash) then
    begin
      mth := TlkJSONobjectmethod(fList.Items[Idx]);
      ht.AddPair(mth.FName,Idx);
    end;
{$ENDIF}
end;

class function TlkJSONobject.Generate(AUseHash: Boolean = True):
  TlkJSONobject;
begin
  Result := TlkJSONobject.Create(AUseHash);
end;

function TlkJSONobject.OldGetField(nm: WideString): TlkJSONbase;
var
  mth: TlkJSONobjectmethod;
  i: Integer;
begin
  i := IndexOfName(nm);
  if i = -1 then
    begin
      Result := Nil;
    end
  else
    begin
{
      mth := TlkJSONobjectmethod(FValue[i]);
}
      mth := TlkJSONobjectmethod(fList.Items[i]);
      Result := mth.FValue;
    end;
end;

function TlkJSONobject.IndexOfName(const aName: WideString): Integer;
var
  mth: TlkJSONobjectmethod;
  i: Integer;
begin
  if not FUseHash then
    begin
      Result := -1;
      for i := 0 to Count - 1 do
        begin
{
          mth := TlkJSONobjectmethod(FValue[i]);
}
          mth := TlkJSONobjectmethod(fList.Items[i]);
          if mth.Name = aName then
            begin
              Result := i;
              break;
            end;
        end;
    end
  else
    begin
      Result := ht.IndexOf(aName);
    end;
end;

function TlkJSONobject.IndexOfObject(aobj: TlkJSONbase): Integer;
var
  mth: TlkJSONobjectmethod;
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    begin
{
      mth := TlkJSONobjectmethod(FValue[i]);
}
      mth := TlkJSONobjectmethod(fList.Items[i]);
      if mth.FValue = aobj then
        begin
          Result := i;
          break;
        end;
    end;
end;

procedure TlkJSONobject.OldSetField(nm: WideString; const AValue:
  TlkJSONbase);
var
  mth: TlkJSONobjectmethod;
  i: Integer;
begin
  i := IndexOfName(nm);
  if i <> -1 then
    begin
{
      mth := TlkJSONobjectmethod(FValue[i]);
}
      mth := TlkJSONobjectmethod(fList.Items[i]);
      mth.FValue := AValue;
    end;
end;

function TlkJSONobject.Add(const aName: WideString; nmb: Double):
  Integer;
begin
  Result := Self.Add(aName, TlkJSONnumber.Generate(nmb));
end;

function TlkJSONobject.Add(const aName: WideString; bool: Boolean):
  Integer;
begin
  Result := Self.Add(aName, TlkJSONboolean.Generate(bool));
end;

function TlkJSONobject.Add(const aName: WideString; s: String):
  Integer;
begin
  Result := Self.Add(aName, TlkJSONstring.Generate(WideString(s)));
end;

function TlkJSONobject.Add(const aName: WideString; inmb: Integer):
  Integer;
begin
  Result := Self.Add(aName, TlkJSONnumber.Generate(inmb));
end;

function TlkJSONobject.Add(const aName, ws: WideString): Integer;
begin
  Result := Self.Add(aName, TlkJSONstring.Generate(ws));
end;

class function TlkJSONobject.SelfType: TlkJSONtypes;
begin
  Result := jsObject;
end;

class function TlkJSONobject.SelfTypeName: String;
begin
  Result := 'jsObject';
end;

function TlkJSONobject.GetFieldByIndex(Idx: Integer): TlkJSONbase;
var
  nm: WideString;
begin
  nm := GetNameOf(Idx);
  if nm <> '' then
    begin
      Result := Field[nm];
    end
  else
    begin
      Result := Nil;
    end;
end;

function TlkJSONobject.GetNameOf(Idx: Integer): WideString;
var
  mth: TlkJSONobjectmethod;
begin
  if (Idx < 0) or (Idx >= Count) then
    begin
      Result := '';
    end
  else
    begin
      mth := Child[Idx] as TlkJSONobjectmethod;
      Result := mth.Name;
    end;
end;

procedure TlkJSONobject.SetFieldByIndex(Idx: Integer; const AValue: TlkJSONbase);
var
  nm: WideString;
begin
  nm := GetNameOf(Idx);
  if nm <> '' then
    begin
      Field[nm] := AValue;
    end;
end;

function TlkJSONobject.ForEachElement(Idx: Integer; var nm: String): TlkJSONbase;
begin
  nm := GetNameOf(Idx);
  Result := GetFieldByIndex(Idx);
end;

function TlkJSONobject.GetField(aName: Variant):TlkJSONbase;
begin
  if VarIsStr(aName) then
    Result := OldGetField(VarToWideStr(aName)) else
    Result := inherited GetField(aName);
end;

{$IFDEF USE_HASH}
function TlkJSONobject.GetHashTable: TlkHashTable;
{$ELSE}
function TlkJSONobject.GetHashTable: TlkBalTree;
{$ENDIF USE_HASH}
begin
  Result := ht;
end;

constructor TlkJSONobject.Create(bUseHash: Boolean = True);
begin
  inherited Create;
  FUseHash := bUseHash;
{$IFDEF USE_HASH}
  ht := TlkHashTable.Create;
  ht.FParent := Self;
{$ELSE}
  ht := TlkBalTree.Create;
{$ENDIF}
end;

destructor TlkJSONobject.Destroy;
begin
  if Assigned(ht) then FreeAndNil(ht);
  inherited;
end;

function TlkJSONobject.getDouble
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double;
var
  jn: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONnumber{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jn := FieldByIndex[Idx] as TlkJSONbase;
  if not Assigned(jn) or (jn.SelfType = jsNull) then
  begin
    Result := 0;
    Null := True;
  end
  else
  begin
    Result := TlkJSONnumber(jn).Value;
    Null := False;
  end;
{$ELSE}
  jn := FieldByIndex[Idx] as TlkJSONnumber;
  if not Assigned(jn) then Result := 0
  else Result := jn.Value;
{$ENDIF}
end;

function TlkJSONobject.getInt
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer;
var
  jn: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONnumber{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jn := FieldByIndex[Idx] as TlkJSONbase;
  if not Assigned(jn) or (jn.SelfType = jsNull) then
  begin
    Result := 0;
    Null := True;
  end
  else
  begin
    Result := Round(Int(TlkJSONnumber(jn).Value));
    Null := False;
  end;
{$ELSE}
  jn := FieldByIndex[Idx] as TlkJSONnumber;
  if not Assigned(jn) then Result := 0
  else Result := Round(Int(jn.Value));
{$ENDIF}
end;

function TlkJSONobject.getString
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String;
var
  js: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONstring{$ENDIF};
begin
{$IFDEF NULL_SQL}
  js := FieldByIndex[Idx] as TlkJSONbase;
  if not Assigned(js) or (js.SelfType = jsNull) then
  begin
    Result := '';
    Null := True;
  end
  else
  begin
    Result := VarToStr(TlkJSONstring(js).Value);
    Null := False;
  end;
{$ELSE}
  js := FieldByIndex[Idx] as TlkJSONstring;
  if not Assigned(js) then Result := ''
  else Result := VarToStr(js.Value);
{$ENDIF}
end;

function TlkJSONobject.getWideString
  (Idx: Integer{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString;
var
  js: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONstring{$ENDIF};
begin
{$IFDEF NULL_SQL}
  js := FieldByIndex[Idx] as TlkJSONbase;
  if not Assigned(js) or (js.SelfType = jsNull) then
  begin
    Result := '';
    Null := True;
  end
  else
  begin
    Result := VarToWideStr(TlkJSONstring(js).Value);
    Null := False;
  end;
{$ELSE}
  js := FieldByIndex[Idx] as TlkJSONstring;
  if not Assigned(js) then Result := ''
  else Result := VarToWideStr(js.Value);
{$ENDIF}
end;

{$IFDEF TCB_EXT}
function TlkJSONobject.getDoubleFromName
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double;
{$ELSE}
function TlkJSONobject.getDouble
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Double;
{$ENDIF}
begin
  Result := getDouble(IndexOfName(WideString(nm)){$IFDEF NULL_SQL}, Null{$ENDIF});
end;

{$IFDEF TCB_EXT}
function TlkJSONobject.getIntFromName
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer;
{$ELSE}
function TlkJSONobject.getInt
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Integer;
{$ENDIF}
begin
  Result := getInt(IndexOfName(WideString(nm)){$IFDEF NULL_SQL}, Null{$ENDIF});
end;

{$IFDEF TCB_EXT}
function TlkJSONobject.getStringFromName
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String;
{$ELSE}
function TlkJSONobject.getString
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): String;
{$ENDIF}
begin
  Result := getString(IndexOfName(WideString(nm)){$IFDEF NULL_SQL}, Null{$ENDIF});
end;

{$IFDEF TCB_EXT}
function TlkJSONobject.getWideStringFromName
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString;
{$ELSE}
function TlkJSONobject.getWideString
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): WideString;
{$ENDIF}
begin
  Result := getWideString(IndexOfName(WideString(nm)){$IFDEF NULL_SQL}, Null{$ENDIF});
end;

function TlkJSONobject.getBoolean
  (Idx: Integer {$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean;
var
  jb: {$IFDEF NULL_SQL}TlkJSONbase{$ELSE}TlkJSONBoolean{$ENDIF};
begin
{$IFDEF NULL_SQL}
  jb := FieldByIndex[Idx] as TlkJSONbase;
  if not Assigned(jb) or (jb.SelfType = jsNull) then
  begin
    Result := False;
    Null := True;
  end
  else
  begin
    Result := TlkJSONboolean(jb).Value;
    Null := False;
  end;
{$ELSE}
  jb := FieldByIndex[Idx] as TlkJSONboolean;
  if not Assigned(jb) then Result := false
  else Result := jb.Value;
{$ENDIF}
end;

{$IFDEF TCB_EXT}
function TlkJSONobject.getBooleanFromName
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean;
{$ELSE}
function TlkJSONobject.getBoolean
  (nm: String{$IFDEF NULL_SQL}; var Null: Boolean{$ENDIF}): Boolean;
{$ENDIF}
begin
  Result := getBoolean(IndexOfName(WideString(nm)){$IFDEF NULL_SQL}, Null{$ENDIF});
end;

{ TlkJSON }

{ исправлено
class function TlkJSON.GenerateText(Obj: TlkJSONbase): String;
}
class function TlkJSON.GenerateText(Obj: TlkJSONbase; conv: Boolean = False): String;
var
{$IFDEF HAVE_FORMATSETTING}
  fs: TFormatSettings;
{$ENDIF}
  pt1, pt0, pt2: PChar;
  ptsz: Cardinal;

{$IFNDEF NEW_STYLE_GENERATE}
  function gn_base(Obj: TlkJSONbase): String;
  var
    ws: String;
    i, j: Integer;
    xs: TlkJSONstring;
  begin
    Result := '';
    if not Assigned(Obj) then Exit;
    if Obj is TlkJSONnumber then
      begin
{$IFDEF HAVE_FORMATSETTING}
        Result := FloatToStr(TlkJSONnumber(Obj).FValue, fs);
{$ELSE}
        Result := FloatToStr(TlkJSONnumber(Obj).FValue);
        i := Pos(DecimalSeparator, Result);
        if (DecimalSeparator <> '.') and (i > 0) then
          Result[i] := '.';
{$ENDIF}
      end
    else if Obj is TlkJSONstring then
      begin
{ исправлено
        ws := UTF8Encode(TlkJSONstring(Obj).FValue;
}
        if conv then
          ws := UTF8Encode(TlkJSONstring(Obj).FValue)
        else
          ws := VarToStr(TlkJSONstring(Obj).FValue);
        i := 1;
        Result := '"';
        while i <= Length(ws) do
          begin
            case ws[i] of
              '/', '\', '"': Result := Result + '\' + ws[i];
              #8: Result := Result + '\b';
              #9: Result := Result + '\T^';
              #10: Result := Result + '\n';
              #13: Result := Result + '\r';
              #12: Result := Result + '\f';
            else
              if Ord(ws[i]) < 32 then
                Result := Result + '\u' + inttohex(Ord(ws[i]), 4)
              else
                Result := Result + ws[i];
            end;
            Inc(i);
          end;
        Result := Result + '"';
      end
    else if Obj is TlkJSONboolean then
      begin
        if TlkJSONboolean(Obj).FValue then
          Result := 'true'
        else
          Result := 'false';
      end
    else if Obj is TlkJSONnull then
      begin
        Result := 'null';
      end
    else if Obj is TlkJSONlist then
      begin
        Result := '[';
        j := TlkJSONobject(Obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then Result := Result + ',';
            Result := Result + gn_base(TlkJSONlist(Obj).Child[i]);
          end;
        Result := Result + ']';
      end
    else if Obj is TlkJSONobjectmethod then
      begin
        try
          xs := TlkJSONstring.Create;
          xs.FValue := TlkJSONobjectmethod(Obj).FName;
          Result := gn_base(TlkJSONbase(xs)) + ':';
          Result := Result +
            gn_base(TlkJSONbase(TlkJSONobjectmethod(Obj).FValue));
        finally
          if Assigned(xs) then FreeAndNil(xs);
        end;
      end
    else if Obj is TlkJSONobject then
      begin
        Result := '{';
        j := TlkJSONobject(Obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then Result := Result + ',';
            Result := Result + gn_base(TlkJSONobject(Obj).Child[i]);
          end;
        Result := Result + '}';
      end;
  end;
{$ELSE}

  procedure get_more_memory;
  var
    delta: Cardinal;
  begin
    delta := 50000;
    if pt0 = Nil then
      begin
        pt0 := AllocMem(delta);
        ptsz := 0;
        pt1 := pt0;
      end
    else
      begin
        ReallocMem(pt0, ptsz + delta);
        // pt1 := Pointer(Cardinal(pt0) + ptsz);
        pt1 := Pointer(pt0 + ptsz);
      end;
    ptsz := ptsz + delta;
    // pt2 := Pointer(Cardinal(pt1) + delta);
    pt2 := Pointer(pt1 + delta);
  end;

  procedure mem_ch(ch: char);
  begin
    if pt1 >= pt2 then get_more_memory;
    pt1^ := ch;
    Inc(pt1);
  end;

  procedure mem_write(rs: String);
  var
    i: Integer;
  begin
    for i := 1 to Length(rs) do
      begin
        if pt1 >= pt2 then get_more_memory;
        pt1^ := rs[i];
        Inc(pt1);
      end;
  end;

  procedure gn_base(Obj: TlkJSONbase);
  var
    xs: TlkJSONstring;
    i, j: Integer;
    ws: String;
  begin
    if not Assigned(Obj) then Exit;
    if Obj is TlkJSONnumber then
      begin
{$IFDEF HAVE_FORMATSETTING}
        mem_write(FloatToStr(TlkJSONnumber(Obj).FValue, fs));
{$ELSE}
        ws := FloatToStr(TlkJSONnumber(Obj).FValue);
        i := Pos(DecimalSeparator, ws);
        if (DecimalSeparator <> '.') and (i > 0) then ws[i] := '.';
        mem_write(ws);
{$ENDIF}
      end
    else if Obj is TlkJSONstring then
      begin
{ исправлено
        ws := UTF8Encode(TlkJSONstring(Obj).FValue)
}
        if conv then
          ws := UTF8Encode(TlkJSONstring(Obj).FValue)
        else
          ws := VarToStr(TlkJSONstring(Obj).FValue);
        i := 1;
        mem_ch('"');
        while i <= Length(ws) do
          begin
            case ws[i] of
              '/', '\', '"':
                begin
                  mem_ch('\');
                  mem_ch(ws[i]);
                end;
              #8: mem_write('\b');
              #9: mem_write('\T^');
              #10: mem_write('\n');
              #13: mem_write('\r');
              #12: mem_write('\f');
            else
              if Ord(ws[i]) < 32 then
                mem_write('\u' + inttohex(Ord(ws[i]), 4))
              else
                mem_ch(ws[i]);
            end;
            Inc(i);
          end;
        mem_ch('"');
      end
    else if Obj is TlkJSONboolean then
      begin
        if TlkJSONboolean(Obj).FValue then
          mem_write('true')
        else
          mem_write('false');
      end
    else if Obj is TlkJSONnull then
      begin
        mem_write('null');
      end
    else if Obj is TlkJSONlist then
      begin
        mem_ch('[');
        j := TlkJSONlist(Obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TlkJSONlist(Obj).Child[i]);
          end;
        mem_ch(']');
      end
    else if Obj is TlkJSONobjectmethod then
      begin
        try
          xs := TlkJSONstring.Create;
          xs.FValue := TlkJSONobjectmethod(Obj).FName;
          gn_base(TlkJSONbase(xs));
          mem_ch(':');
          gn_base(TlkJSONbase(TlkJSONobjectmethod(Obj).FValue));
        finally
          if Assigned(xs) then FreeAndNil(xs);
        end;
      end
    else if Obj is TlkJSONobject then
      begin
        mem_ch('{');
        j := TlkJSONobject(Obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TlkJSONobject(Obj).Child[i]);
          end;
        mem_ch('}');
      end;
  end;
{$ENDIF NEW_STYLE_GENERATE}

begin
{$IFDEF HAVE_FORMATSETTING}
  GetLocaleFormatSettings(GetThreadLocale, fs);
  fs.DecimalSeparator := '.';
{$ENDIF}
{$IFDEF NEW_STYLE_GENERATE}
  pt0 := Nil;
  get_more_memory;
  gn_base(Obj);
  mem_ch(#0);
  Result := String(pt0);
  freemem(pt0);
{$ELSE}
  Result := gn_base(Obj);
{$ENDIF}
end;

{ исправлено
class function TlkJSON.ParseText(const Txt: String): TlkJSONbase;
}
class function TlkJSON.ParseText(const Txt: String; conv: Boolean = False): TlkJSONbase;
{$IFDEF HAVE_FORMATSETTING}
var
  fs: TFormatSettings;
{$ENDIF}

  function js_base(Idx: Integer; var rIdx: Integer; var o:
    TlkJSONbase): Boolean; forward;

  function xe(Idx: Integer): Boolean;
  {$IFDEF FPC}inline;
  {$ENDIF}
  begin
    Result := Idx <= Length(Txt);
  end;

  procedure skip_spc(var Idx: Integer);
  {$IFDEF FPC}inline;
  {$ENDIF}
  begin
    while (xe(Idx)) and (Ord(Txt[Idx]) < 33) do
      Inc(Idx);
  end;

  procedure add_child(var o, c: TlkJSONbase);
  var
    i: Integer;
  begin
    if o = Nil then
    begin
      o := c;
    end
    else
      begin
        if o is TlkJSONobjectmethod then
          begin
            TlkJSONobjectmethod(o).FValue := c;
          end
        else if o is TlkJSONlist then
          begin
            TlkJSONlist(o)._Add(c);
          end
        else if o is TlkJSONobject then
          begin
            i := TlkJSONobject(o)._Add(c);
            if TlkJSONobject(o).UseHash then
{$IFDEF USE_HASH}
              TlkJSONobject(o).ht.AddPair(TlkJSONobjectmethod(c).Name, i);
{$ELSE}
              TlkJSONobject(o).ht.Insert(TlkJSONobjectmethod(c).Name, i);
{$ENDIF USE_HASH}
          end;
      end;
  end;

  function js_boolean
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    js: TlkJSONboolean;
  begin
{ исправлено
}

    skip_spc(Idx);
    if Copy(Txt, Idx, 4) = 'true' then
      begin
        Result := True;
        rIdx := Idx + 4;
        js := TlkJSONboolean.Create;
        js.FValue := True;
        add_child(o, TlkJSONbase(js));
      end
{ исправлено
}
    else if Copy(Txt, Idx, 5) = 'false' then
      begin
        Result := True;
        rIdx := Idx + 5;
        js := TlkJSONboolean.Create;
        js.FValue := False;
        add_child(o, TlkJSONbase(js));
      end
    else
      begin
        Result := False;
      end;
  end;

  function js_null
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    js: TlkJSONnull;
  begin
    skip_spc(Idx);
{ исправлено
}
    if Copy(Txt, Idx, 4) = 'null' then
      begin
        Result := True;
        rIdx := Idx + 4;
        js := TlkJSONnull.Create;
        add_child(o, TlkJSONbase(js));
      end
    else
      begin
        Result := False;
      end;
  end;

  function js_integer(Idx: Integer; var rIdx: Integer): Boolean;
  begin
    Result := False;
    while (xe(Idx)) and (Txt[Idx] in ['0'..'9']) do
      begin
        Result := True;
        Inc(Idx);
      end;
    if Result then rIdx := Idx;
  end;

  function js_number
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    js: TlkJSONnumber;
    ws: String;
  {$IFNDEF HAVE_FORMATSETTING}
    i: Integer;
  {$ENDIF}
  begin
    skip_spc(Idx);
    Result := xe(Idx);
    if not Result then Exit;
    if Txt[Idx] in ['+', '-'] then
      begin
        Inc(Idx);
        Result := xe(Idx);
      end;
    if not Result then Exit;
    Result := js_integer(Idx, Idx);
    if not Result then Exit;
    if (xe(Idx)) and (Txt[Idx] = '.') then
      begin
        Inc(Idx);
        Result := js_integer(Idx, Idx);
        if not Result then Exit;
      end;
    if (xe(Idx)) and (Txt[Idx] in ['e', 'E']) then
      begin
        Inc(Idx);
        if (xe(Idx)) and (Txt[Idx] in ['+', '-']) then Inc(Idx);
        Result := js_integer(Idx, Idx);
        if not Result then Exit;
      end;
    if not Result then Exit;
    js := TlkJSONnumber.Create;
    ws := copy(Txt, rIdx, Idx - rIdx);
{$IFDEF HAVE_FORMATSETTING}
    js.FValue := StrToFloat(ws, fs);
{$ELSE}
    i := Pos('.', ws);
    if (DecimalSeparator <> '.') and (i > 0) then
      ws[Pos('.', ws)] := DecimalSeparator;
    js.FValue := StrToFloat(ws);
{$ENDIF}
    add_child(o, TlkJSONbase(js));
    rIdx := Idx;
  end;

  function js_string
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;

    function strSpecialChars(const s: String): String;
    var
      i, j : Integer;
    begin
      i := Pos('\', s);
      if (i = 0) then
        Result := s
      else
      begin
        Result := Copy(s, 1, i-1);
        j := i;
        repeat
          if (s[j] = '\') then
          begin
            Inc(j);
            case s[j] of
              '\': Result := Result + '\';
              '"': Result := Result + '"';
              '''': Result := Result + '''';
              '/': Result := Result + '/';
              'b': Result := Result + #8;
              'f': Result := Result + #12;
              'n': Result := Result + #10;
              'r': Result := Result + #13;
              'T': Result := Result + #9;
              'u':
                begin
                  Result := Result + Code2UTF(StrToint('$' + Copy(s, j + 1, 4)));
                  Inc(j, 4);
                end;
            end;
          end
          else
            Result := Result + s[j];
          Inc(j);
        until j > Length(s);
      end;
    end;

  var
    js: TlkJSONstring;
    i, j, wIdx: Integer;
    fin: Boolean;
    ws: String = '';
  begin
    skip_spc(Idx);

    Result := xe(Idx) and (Txt[Idx] = '"');
    if not Result then Exit;

    Inc(Idx);
    wIdx := Idx;

    fin := False;
    repeat
      i := 0;
      j := 0;
      while (wIdx <= Length(Txt)) and (j = 0) do
      begin
        if (i = 0) and (Txt[wIdx] = '\') then i := wIdx;
        if (j = 0) and (Txt[wIdx] = '"') then j := wIdx;
        Inc(wIdx);
      end;
      // incorrect string!!!
      if j = 0 then
        begin
          Result := False;
          Exit;
        end;
      // if we have no slashed chars in string
      if (i = 0) or (j < i) then
        begin
          ws := Copy(Txt, Idx, j - Idx);
          Idx := j;
          fin := True;
        end
      // if i>0 and j>=i - skip slashed char
      else
        begin
          wIdx:=i + 2;
        end;
    UNTIL fin;

    ws := strSpecialChars(ws);
    Inc(Idx);

    js := TlkJSONstring.Create;

// исправлено
//{$IFDEF USE_D2009}
//    js.FValue := UTF8ToString(ws)
//{$ELSE}
//    js.FValue := UTF8Decode(ws)
//{$ENDIF}
//
    if conv then
{$IFDEF USE_D2009}
      js.FValue := UTF8ToString(ws)
{$ELSE}
      js.FValue := UTF8Decode(ws)
{$ENDIF}
    else
      js.FValue := WideString(ws);

    add_child(o, TlkJSONbase(js));
    rIdx := Idx;
  end;

  function js_list
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    js: TlkJSONlist;
  begin
    Result := False;
    try
      js := TlkJSONlist.Create;
      skip_spc(Idx);
      Result := xe(Idx);
      if not Result then Exit;
      Result := Txt[Idx] = '[';
      if not Result then Exit;
      Inc(Idx);
      while js_base(Idx, Idx, TlkJSONbase(js)) do
        begin
          skip_spc(Idx);
          if (xe(Idx)) and (Txt[Idx] = ',') then Inc(Idx);
        end;
      skip_spc(Idx);
      Result := (xe(Idx)) and (Txt[Idx] = ']');
      if not Result then Exit;
      Inc(Idx);
    finally
      if not Result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TlkJSONbase(js));
          rIdx := Idx;
        end;
    end;
  end;

  function js_method
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    mth: TlkJSONobjectmethod;
    ws: TlkJSONstring;
  begin
    Result := False;
    try
      ws := Nil;
      mth := TlkJSONobjectmethod.Create;
      skip_spc(Idx);
      Result := xe(Idx);
      if not Result then Exit;
      Result := js_string(Idx, Idx, TlkJSONbase(ws));
      if not Result then Exit;
      skip_spc(Idx);
      Result := xe(Idx) and (Txt[Idx] = ':');
      if not Result then Exit;
      Inc(Idx);
      mth.FName := ws.FValue;
      Result := js_base(Idx, Idx, TlkJSONbase(mth));
    finally
      if ws <> Nil then ws.Free;
      if Result then
        begin
          add_child(o, TlkJSONbase(mth));
          rIdx := Idx;
        end
      else
        begin
          mth.Free;
        end;
    end;
  end;

  function js_object
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  var
    js: TlkJSONobject;
  begin
    Result := False;
    try
      js := TlkJSONobject.Create;
      skip_spc(Idx);
      Result := xe(Idx);
      if not Result then Exit;
      Result := Txt[Idx] = '{';
      if not Result then Exit;
      Inc(Idx);
      while js_method(Idx, Idx, TlkJSONbase(js)) do
        begin
          skip_spc(Idx);
          if (xe(Idx)) and (Txt[Idx] = ',') then Inc(Idx);
        end;
      skip_spc(Idx);  
      Result := (xe(Idx)) and (Txt[Idx] = '}');
      if not Result then Exit;
      Inc(Idx);
    finally
      if not Result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TlkJSONbase(js));
          rIdx := Idx;
        end;
    end;
  end;

  function js_base
    (Idx: Integer; var rIdx: Integer; var o: TlkJSONbase): Boolean;
  begin
    skip_spc(Idx);
    Result := js_boolean(Idx, Idx, o);
    if not Result then Result := js_null(Idx, Idx, o);
    if not Result then Result := js_number(Idx, Idx, o);
    if not Result then Result := js_string(Idx, Idx, o);
    if not Result then Result := js_list(Idx, Idx, o);
    if not Result then Result := js_object(Idx, Idx, o);
    if Result then rIdx := Idx;
  end;

var
  Idx: Integer;
begin
{$IFDEF HAVE_FORMATSETTING}
  GetLocaleFormatSettings(GetThreadLocale, fs);
  fs.DecimalSeparator := '.';
{$ENDIF}

  Result := Nil;
  if Txt = '' then Exit;
  try
    Idx := 1;
    // skip a BOM utf8 marker
    if Copy(Txt, Idx, 3) = #239#187#191 then
    begin
      Inc(Idx, 3);
      // if there are only a BOM - Exit;
      if Idx > Length(Txt) then Exit;
    end;
    if not js_base(Idx, Idx, Result) then FreeAndNil(Result);
  except
    if Assigned(Result) then FreeAndNil(Result);
  end;
end;

{ ElkIntException }

constructor ElkIntException.Create(AIdx: Integer; AMsg: String);
begin
  Self.Idx := AIdx;
  inherited Create(AMsg);
end;

{ TlkHashTable }

{$IFDEF USE_HASH}
procedure TlkHashTable.AddPair(const ws: WideString; Idx: Integer);
var
  i, j, k: Cardinal;
  p: PlkHashItem;
  find: boolean;
begin
  find := False;
  if InTable(ws, i, j, k) then
    begin
    // if string is already in table, changing index
      if TlkJSONobject(FParent).GetNameOf(PlkHashItem(a_x[j].Items[k])^.index) = ws then
        begin
           PlkHashItem(a_x[j].Items[k])^.index := Idx;
           find := True;
        end;
    end;
  if find = false then
    begin
      GetMem(p,sizeof(TlkHashItem));
      k := a_x[j].Add(p);
      p^.hash := i;
      p^.index := Idx;
      while (k>0) and (PlkHashItem(a_x[j].Items[k])^.hash < PlkHashItem(a_x[j].Items[k-1])^.hash) do
        begin
          a_x[j].Exchange(k,k-1);
          dec(k);
        end;
    end;
end;

function TlkHashTable.counters: String;
var
  i, j: Integer;
  ws: String;
begin
  ws := '';
  for i := 0 to 15 do
    begin
      for j := 0 to 15 do
//        ws := ws + format('%.3d ', [Length(a_h[i * 16 + j])]);
        ws := ws + format('%.3d ', [a_x[i * 16 + j].Count]);
      ws := ws + #13#10;
    end;
  Result := ws;
end;

procedure TlkHashTable.Delete(const ws: WideString);
var
  i, j, k: Cardinal;
begin
  if InTable(ws, i, j, k) then
    begin
//      while k < High(a_h[j]) do
//        begin
//          hswap(j, k, k + 1);
//          Inc(k);
//        end;
//      SetLength(a_h[j], k);
      FreeMem(a_x[j].Items[k]);
      a_x[j].Delete(k);
    end;
end;

{$IFDEF THREADSAFE}
const
  rnd_table: array[0..255] of byte =
  (216, 191, 234, 201, 12, 163, 190, 205, 128, 199, 210, 17, 52, 43,
    38, 149, 40, 207, 186, 89, 92, 179, 142, 93, 208, 215, 162,
    161, 132, 59, 246, 37, 120, 223, 138, 233, 172, 195, 94, 237, 32,
    231, 114, 49, 212, 75, 198, 181, 200, 239, 90, 121, 252, 211,
    46, 125, 112, 247, 66, 193, 36, 91, 150, 69, 24, 255, 42, 9, 76,
    227, 254, 13, 192, 7, 18, 81, 116, 107, 102, 213, 104, 15, 250,
    153, 156, 243, 206, 157, 16, 23, 226, 225, 196, 123, 54, 101,
    184, 31, 202, 41, 236, 3, 158, 45, 96, 39, 178, 113, 20, 139, 6,
    245, 8, 47, 154, 185, 60, 19, 110, 189, 176, 55, 130, 1, 100,
    155, 214, 133, 88, 63, 106, 73, 140, 35, 62, 77, 0, 71, 82, 145,
    180,
    171, 166, 21, 168, 79, 58, 217, 220, 51, 14, 221, 80, 87, 34, 33,
    4, 187, 118, 165, 248, 95, 10, 105, 44, 67, 222, 109, 160, 103,
    242, 177, 84, 203, 70, 53, 72, 111, 218, 249, 124, 83, 174, 253,
    240, 119, 194, 65, 164, 219, 22, 197, 152, 127, 170, 137, 204,
    99, 126, 141, 64, 135, 146, 209, 244, 235, 230, 85, 232, 143,
    122, 25, 28, 115, 78, 29, 144, 151, 98, 97, 68, 251, 182, 229,
    56,
    159, 74, 169, 108, 131, 30, 173, 224, 167, 50, 241, 148, 11, 134,
    117, 136, 175, 26, 57, 188, 147, 238, 61, 48, 183, 2, 129,
    228, 27, 86, 5);
{$ELSE}
var
  rnd_table: array[0..255] of byte;
{$ENDIF}

function TlkHashTable.DefaultHashOf(const ws: WideString): Cardinal;
{$IFDEF DOTNET}
var
  i, j: Integer;
  x1, x2, x3, x4: byte;
begin
  Result := 0;
//  Result := 0;
  x1 := 0;
  x2 := 1;
  for i := 1 to Length(ws) do
    begin
      j := Ord(ws[i]);
      // first version of hashing
      x1 := (x1 + j) {and $FF};
      x2 := (x2 + 1 + (j shr 8)) {and $FF};
      x3 := rnd_table[x1];
      x4 := rnd_table[x3];
      Result := ((x1 * x4) + (x2 * x3)) xor Result;
    end;
end;
{$ELSE}
var
  x1, x2, x3, x4: byte;
  p: PWideChar;
begin
  Result := 0;
  x1 := 0;
  x2 := 1;
  p := PWideChar(ws);
  while p^ <> #0 do
    begin
      Inc(x1, Ord(p^)) {and $FF};
      Inc(x2, 1 + (Ord(p^) shr 8)) {and $FF};
      x3 := rnd_table[x1];
      x4 := rnd_table[x3];
      Result := ((x1 * x4) + (x2 * x3)) xor Result;
      Inc(p);
    end;
end;
{$ENDIF}

procedure TlkHashTable.hswap(j, k, l: Integer);
//var
//  h: TlkHashItem;
begin
//  h := a_h[j, k];
//  a_h[j, k] := a_h[j, l];
//  a_h[j, l] := h;
  a_x[j].Exchange(k, l);
end;

function TlkHashTable.IndexOf(const ws: WideString): Integer;
var
  i, j, k: Cardinal;
begin
  if not InTable(ws, i, j, k) then
    begin
      Result := -1;
    end
  else
    begin
//      Result := a_h[j, k].index;
      Result := PlkHashItem(a_x[j].Items[k])^.index;
    end;
end;

function TlkHashTable.InTable(const ws: WideString; var i, j, k:
  Cardinal):
  Boolean;
var
  l, wu, wl: Integer;
  x: Cardinal;
  fin: Boolean;
begin
  i := HashOf(ws);
  j := i and $FF;
  Result := False;
  {using "binary" search always, because array is sorted}
  if a_x[j].Count-1 >= 0 then
    begin
      wl := 0;
      wu := a_x[j].Count-1;
      repeat
        fin := True;
        if PlkHashItem(a_x[j].Items[wl])^.hash = i then
          begin
            k := wl;
            Result := True;
          end
        else if PlkHashItem(a_x[j].Items[wu])^.hash = i then
          begin
            k := wu;
            Result := True;
          end
        else if (wu - wl) > 1 then
          begin
            fin := False;
            x := (wl + wu) shr 1;
            if PlkHashItem(a_x[j].Items[x])^.hash > i then
              begin
                wu := x;
              end
            else
              begin
                wl := x;
              end;
          end;
      until fin;
    end;

  // verify k index in chain
  if Result = True then
    begin
      while (k > 0) and (PlkHashItem(a_x[j].Items[k])^.hash = PlkHashItem(a_x[j].Items[k-1])^.hash) do dec(k);
      repeat
        fin := True;
        if TlkJSONobject(FParent).GetNameOf(PlkHashItem(a_x[j].Items[k])^.index) <> ws then
          begin
            if k < a_x[j].Count-1 then
              begin
                Inc(k);
                fin := False;
              end
            else
              begin
                Result := False;
              end;
          end
        else
          begin
            Result := True;
          end;
      until fin;
    end;
end;

{$IFNDEF THREADSAFE}
procedure init_rnd;
var
  x0: Integer;
  i: Integer;
begin
  x0 := 5;
  for i := 0 to 255 do
    begin
      x0 := (x0 * 29 + 71) and $FF;
      rnd_table[i] := x0;
    end;
end;
{$ENDIF}

procedure TlkHashTable.SetHashFunction(const AValue:
  TlkHashFunction);
begin
  FHashFunction := AValue;
end;

constructor TlkHashTable.Create;
var
  i: Integer;
begin
  inherited;
  //  for i := 0 to 255 do SetLength(a_h[i], 0);
  for i := 0 to 255 do a_x[i] := TList.Create;
  HashOf := {$IFDEF FPC}@{$ENDIF}DefaultHashOf;
end;

destructor TlkHashTable.Destroy;
var
  i, j: Integer;
begin
  //  for i := 0 to 255 do SetLength(a_h[i], 0);
  for i := 0 to 255 do
    begin
      for j := 0 to a_x[i].Count - 1 do Freemem(a_x[i].Items[j]);
      a_x[i].Free;
    end;
  inherited;
end;

function TlkHashTable.SimpleHashOf(const ws: WideString): Cardinal;
var
  i: Integer;
begin
  Result := Length(ws);
  for i := 1 to Length(ws) do Result := Result + Ord(ws[i]);
end;
{$ENDIF USE_HASH}

{ TlkJSONstreamed }

{$IFDEF STREAM}
{ исправлено
class function TlkJSONstreamed.LoadFromFile(SrcName: String):
}
class function TlkJSONstreamed.LoadFromFile
  (SrcName: String; Conv: Boolean = False): TlkJSONbase;
var
  fs: TFileStream;
begin
  Result := Nil;
  if not FileExists(SrcName) then Exit;
  try
    fs := TFileStream.Create(SrcName, fmOpenRead);
{ исправлено
    Result := LoadFromStream(fs);
}
    Result := LoadFromStream(fs, Conv);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

{ исправлено
class function TlkJSONstreamed.LoadFromStream(src: TStream): TlkJSONbase;
}
class function TlkJSONstreamed.LoadFromStream
  (Src: TStream; conv: Boolean = False): TlkJSONbase;
var
  ws: String;
  Len: Int64;
begin
  Result := Nil;
  if not Assigned(Src) then Exit;
  Len := Src.Size - Src.Position;
  SetLength(ws, Len);
  Src.Read(PChar(ws)^, Len);
{ исправлено
  Result := ParseText(ws);
}
  Result := ParseText(ws, Conv);
end;

{ исправлено
class procedure TlkJSONstreamed.SaveToFile(Obj: TlkJSONbase; dstname: String);
}
class procedure TlkJSONstreamed.SaveToFile
  (Obj: TlkJSONbase; DstName: String; Conv: Boolean = False);
var
  fs: TFileStream;
begin
  if not Assigned(Obj) then Exit;
  try
    fs := TFileStream.Create(DstName, fmCreate);
{ исправлено
    SaveToStream(Obj, fs);
}
    SaveToStream(Obj, fs, Conv);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

{ исправлено
class procedure TlkJSONstreamed.SaveToStream(Obj: TlkJSONbase; dst: TStream);
}
class procedure TlkJSONstreamed.SaveToStream
  (Obj: TlkJSONbase; Dst: TStream; Conv: Boolean = False);
var
  ws: String;
begin
  if not Assigned(Obj) then Exit;
  if not Assigned(dst) then Exit;
{ исправлено
  ws := GenerateText(Obj);
}
  ws := GenerateText(Obj, Conv);
  Dst.Write(PChar(ws)^, Length(ws));
end;
{$ENDIF STREAM}

{ TlkJSONdotnetclass }

{$IFDEF DOTNET}
procedure TlkJSONdotnetclass.AfterConstruction;
begin

end;

procedure TlkJSONdotnetclass.BeforeDestruction;
begin

end;

constructor TlkJSONdotnetclass.Create;
begin
  inherited;
  AfterConstruction;
end;

destructor TlkJSONdotnetclass.Destroy;
begin
  BeforeDestruction;
  inherited;
end;
{$ENDIF DOTNET}

{ TlkBalTree }

{$IFNDEF USE_HASH}
procedure TlkBalTree.Clear;

  procedure Rec(T: PlkBalNode);
  begin
    if T^.Left <> fBottom then Rec(T^.Left);
    if T^.Right <> fBottom then Rec(T^.Right);
    T^.nm := '';
    Dispose(T);
  end;

begin
  if fRoot <> fBottom then Rec(fRoot);
  fRoot := fBottom;
  fDeleted := fBottom;
end;

function TlkBalTree.Counters: String;
begin
  Result := Format('Balanced tree root node level is %d', [fRoot^.Level]);
end;

constructor TlkBalTree.Create;
begin
  inherited Create;
  New(fBottom);
  fBottom^.Left := fBottom;
  fBottom^.Right := fBottom;
  fBottom^.Level := 0;
  fDeleted := fBottom;
  fRoot := fBottom;
end;

function TlkBalTree.Delete(const ws: WideString): Boolean;

  procedure UpdateKeys(T: PlkBalNode; Idx: Integer);
  begin
    if T <> fBottom then begin
      if T^.Key > Idx then
        T^.Key := T^.Key - 1;
      UpdateKeys(T^.Left, Idx);
      UpdateKeys(T^.Right, Idx);
    end;
  end;

  function Del(var T: PlkBalNode): Boolean;
  begin
    Result := False;
    if T <> fBottom then begin
      fLast := T;
      if ws < T^.nm then
        Result := Del(T^.Left)
      else begin
        fDeleted := T;
        Result := Del(T^.Right);
      end;
      if (T = fLast) and (fDeleted <> fBottom) and (ws = fDeleted^.nm) then
      begin
        UpdateKeys(fRoot, fDeleted^.Key);
        fDeleted^.Key := T^.Key;
        fDeleted^.nm := T^.nm;
        T := T^.Right;
        fLast^.nm := '';
        Dispose(fLast);
        Result := True;
      end
      else if (T^.Left^.Level < (T^.Level - 1)) or (T^.Right^.Level < (T^.Level - 1)) then
      begin
        T^.Level := T^.Level - 1;
        if T^.Right^.Level > T^.Level then
          T^.Right^.Level := T^.Level;
        Skew(T);
        Skew(T^.Right);
        Skew(T^.Right^.Right);
        Split(T);
        Split(T^.Right);
      end;
    end;
  end;

begin
  Result := Del(fRoot);
end;

destructor TlkBalTree.Destroy;
begin
  Clear;
  Dispose(fBottom);
  inherited;
end;

function TlkBalTree.IndexOf(const ws: WideString): Integer;
var
  Tk: PlkBalNode;
begin
  Result := -1;
  Tk := fRoot;
  while (Result = -1) and (Tk <> fBottom) do
    begin
      if Tk^.nm = ws then Result := Tk^.Key
      else if ws < Tk^.nm then Tk := Tk^.Left
      else Tk := Tk^.Right;
    end;
end;

function TlkBalTree.Insert(const ws: WideString; x: Integer): Boolean;

  function Ins(var T: PlkBalNode): Boolean;
  begin
    if T = fBottom then
      begin
        New(T);
        T^.Key := x;
        T^.nm := ws;
        T^.Left := fBottom;
        T^.Right := fBottom;
        T^.Level := 1;
        Result := True;
      end
    else
      begin
        if ws < T^.nm then
          Result := Ins(T^.Left)
        else if ws > T^.nm then
          Result := Ins(T^.Right)
        else Result := False;
        Skew(T);
        Split(T);
      end;
  end;

begin
  Result := Ins(fRoot);
end;

procedure TlkBalTree.Skew(var T: PlkBalNode);
var
  Temp: PlkBalNode;
begin
  if T^.Left^.Level = T^.Level then
    begin
      Temp := T;
      T := T^.Left;
      Temp^.Left := T^.Right;
      T^.Right := Temp;
    end;
end;

procedure TlkBalTree.Split(var T: PlkBalNode);
var
  Temp: PlkBalNode;
begin
  if T^.Right^.Right^.Level = T^.Level then
    begin
      Temp := T;
      T := T^.Right;
      Temp^.Right := T^.Left;
      T^.Left := Temp;
      T^.Level := T^.Level + 1;
    end;
end;
{$ENDIF USE_HASH}

initialization

{$IFNDEF THREADSAFE}
  {$IFDEF USE_HASH}
    init_rnd;
  {$ENDIF USE_HASH}
{$ENDIF THREADSAFE}

end.
