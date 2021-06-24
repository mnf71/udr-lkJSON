/******************************************************************************/
/***                                Domains                                 ***/
/******************************************************************************/



CREATE DOMAIN TY$POINTER AS CHAR(8) CHARACTER SET OCTETS;



/******************************************************************************/
/***                            Package headers                             ***/
/******************************************************************************/



SET TERM ^ ;

CREATE OR ALTER PACKAGE JS$BASE
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONtypes =
       (jsBase, jsNumber, jsString, jsBoolean, jsNull, jsList, jsObject);
        0       1         2         3          4       5       6
  */
  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT; /* 0 - succes */

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128)) RETURNS TY$POINTER; /* js$Base, js$Meth (jsList, jsObject) */

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Value_(Self TY$POINTER, Val VARCHAR(32765) = NULL /* Get */) RETURNS VARCHAR(32765);
  FUNCTION WideValue_(Self TY$POINTER, WVal BLOB SUB_TYPE TEXT = NULL /* Get */) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^


CREATE OR ALTER PACKAGE JS$BOOL
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONboolean = class(TlkJSONbase)
  */
  FUNCTION Value_(Self TY$POINTER, Bool BOOLEAN = NULL /* Get */) RETURNS BOOLEAN;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, Bool BOOLEAN = TRUE) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^


CREATE OR ALTER PACKAGE JS$CUSTLIST
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
  */
  PROCEDURE ForEach
    (Self TY$POINTER) RETURNS (Idx Integer, Name VARCHAR(128), Obj TY$POINTER /* js$Base */);

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128) /* 0.. = Idx */) RETURNS TY$POINTER; /* js$Meth */
  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER) RETURNS BOOLEAN;
  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER) RETURNS DOUBLE PRECISION;
  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER) RETURNS INTEGER;
  FUNCTION GetString(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(32765);
  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER) RETURNS BLOB SUB_TYPE TEXT;
END^


CREATE OR ALTER PACKAGE JS$FUNC
AS
BEGIN
  FUNCTION ParseText(Text BLOB SUB_TYPE TEXT, Conv BOOLEAN = FALSE) RETURNS TY$POINTER;
  FUNCTION ParseString(String VARCHAR(32765), Conv BOOLEAN = FALSE) RETURNS TY$POINTER;

  FUNCTION GenerateText(Obj TY$POINTER, Conv BOOLEAN = FALSE) RETURNS BLOB SUB_TYPE TEXT;
  FUNCTION GenerateString(Obj TY$POINTER, Conv BOOLEAN = FALSE) RETURNS VARCHAR(32765);

  FUNCTION ReadableText(Obj TY$POINTER, Level INTEGER = 0, Conv BOOLEAN = FALSE)
    RETURNS BLOB SUB_TYPE TEXT;
END^


CREATE OR ALTER PACKAGE JS$LIST
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
     TlkJSONlist = class(TlkJSONcustomlist)
  */
  PROCEDURE ForEach
    (Self TY$POINTER) RETURNS (Idx Integer, Name VARCHAR(128), Obj TY$POINTER /* js$Base */);

  FUNCTION Add_(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER;
  FUNCTION AddBoolean(Self TY$POINTER, Bool BOOLEAN) RETURNS INTEGER;
  FUNCTION AddDouble(Self TY$POINTER, Dbl DOUBLE PRECISION) RETURNS INTEGER;
  FUNCTION AddInteger(Self TY$POINTER, Int_ INTEGER) RETURNS INTEGER;
  FUNCTION AddString(Self TY$POINTER, Str VARCHAR(32765)) RETURNS INTEGER;
  FUNCTION AddWideString(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER;

  FUNCTION Delete_(Self TY$POINTER, Idx Integer) RETURNS SMALLINT;
  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER;
  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128) /* 0.. = Idx */) RETURNS TY$POINTER; /* js$Meth */

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^


CREATE OR ALTER PACKAGE JS$METH
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONobjectmethod = class(TlkJSONbase)
  */
  FUNCTION MethodObjValue(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION MethodName(Self TY$POINTER, Name VARCHAR(128) = NULL /* Get */) RETURNS VARCHAR(128);
  FUNCTION MethodGenerate(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER /* js$Base */)
    RETURNS TY$POINTER /* js$Meth */;
END^


CREATE OR ALTER PACKAGE JS$NULL
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONnull = class(TlkJSONbase)
  */
  FUNCTION Value_(Self TY$POINTER) RETURNS SMALLINT;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^


CREATE OR ALTER PACKAGE JS$NUM
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONnumber = class(TlkJSONbase)
  */
  FUNCTION Value_(Self TY$POINTER, Num DOUBLE PRECISION = NULL /* Get */) RETURNS DOUBLE PRECISION;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, Num DOUBLE PRECISION = 0) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^


CREATE OR ALTER PACKAGE JS$OBJ
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
     TlkJSONobject = class(TlkJSONcustomlist)
  */
  FUNCTION New_(UseHash BOOLEAN = TRUE) RETURNS TY$POINTER;
  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT; /* 0 - succes */

  PROCEDURE ForEach(Self TY$POINTER) RETURNS (Idx INTEGER,  Name VARCHAR(128), Obj TY$POINTER /* js$Meth */);

  FUNCTION Add_(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER) RETURNS INTEGER;
  FUNCTION AddBoolean(Self TY$POINTER, Name VARCHAR(128), Bool BOOLEAN) RETURNS INTEGER;
  FUNCTION AddDouble(Self TY$POINTER, Name VARCHAR(128), Dbl DOUBLE PRECISION) RETURNS INTEGER;
  FUNCTION AddInteger(Self TY$POINTER, Name VARCHAR(128), Int_ INTEGER) RETURNS INTEGER;
  FUNCTION AddString(Self TY$POINTER, Name VARCHAR(128), Str VARCHAR(32765)) RETURNS INTEGER;
  FUNCTION AddWideString(Self TY$POINTER, Name VARCHAR(128), WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER;

  FUNCTION Delete_(Self TY$POINTER, Idx Integer) RETURNS SMALLINT;
  FUNCTION IndexOfName(Self TY$POINTER, Name VARCHAR(128)) RETURNS INTEGER;
  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER;
  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, UseHash BOOLEAN = TRUE) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL  /* NULL - class function */) RETURNS VARCHAR(32);

  FUNCTION FieldByIndex(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;
  FUNCTION NameOf(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(128);

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER) RETURNS BOOLEAN;
  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER) RETURNS DOUBLE PRECISION;
  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER) RETURNS INTEGER;
  FUNCTION GetString(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(32765);
  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION GetBooleanByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS BOOLEAN;
  FUNCTION GetDoubleByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS DOUBLE PRECISION;
  FUNCTION GetIntegerByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS INTEGER;
  FUNCTION GetStringByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS VARCHAR(32765);
  FUNCTION GetWideStringByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS BLOB SUB_TYPE TEXT;
END^


CREATE OR ALTER PACKAGE JS$PTR
AS
BEGIN
  FUNCTION New_
    (UsePtr CHAR(3) /* Tra - Transaction, Att - Attachment */, UseHash BOOLEAN = TRUE)
    RETURNS TY$POINTER;
  FUNCTION Dispose(UsePtr CHAR(3)) RETURNS SMALLINT;

  FUNCTION Tra RETURNS TY$POINTER;
  FUNCTION Att RETURNS TY$POINTER;
  
  FUNCTION isNull(jsPtr TY$POINTER) RETURNS BOOLEAN;  
END^


CREATE OR ALTER PACKAGE JS$STR
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONstring = class(TlkJSONbase)
  */
  FUNCTION Value_(Self TY$POINTER, Str VARCHAR(32765) = NULL /* Get */) RETURNS VARCHAR(32765);
  FUNCTION WideValue_(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT = NULL /* Get */) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, Str VARCHAR(32765) = '') RETURNS TY$POINTER;
  FUNCTION WideGenerate(Self TY$POINTER = NULL /* NULL - class function */, WStr BLOB SUB_TYPE TEXT = '') RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */) RETURNS VARCHAR(32);
END^



SET TERM ; ^



/******************************************************************************/
/***                            Package headers                             ***/
/******************************************************************************/



SET TERM ^ ;


SET TERM ; ^



/******************************************************************************/
/***                             Package bodies                             ***/
/******************************************************************************/



SET TERM ^ ;

RECREATE PACKAGE BODY JS$BASE
AS
BEGIN
  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BaseDispose'
    ENGINE UDR;

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128)) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BaseField'
    ENGINE UDR;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!BaseCount'
    ENGINE UDR;

  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BaseChild'
    ENGINE UDR;

  FUNCTION Value_(Self TY$POINTER, Val VARCHAR(32765)) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!BaseValue'
    ENGINE UDR;

  FUNCTION WideValue_(Self TY$POINTER, WVal BLOB SUB_TYPE TEXT) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!BaseWideValue'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BaseSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!BaseSelfTypeName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$BOOL
AS
BEGIN
  FUNCTION Value_(Self TY$POINTER, Bool BOOLEAN) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!BooleanValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER, Bool BOOLEAN) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BooleanGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BooleanSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!BooleanSelfTypeName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$CUSTLIST
AS
BEGIN
  PROCEDURE ForEach
    (Self TY$POINTER) RETURNS (Idx Integer, Name VARCHAR(128), Obj TY$POINTER)
  AS
    DECLARE Count_ INTEGER;
  BEGIN
    Idx = 0;
    Count_ = Count_(Self);
    WHILE (Idx < Count_) DO
    BEGIN
      Name = CAST(Idx AS VARCHAR(128));
      Obj = Child(Self, Idx);
      SUSPEND;
      Idx = Idx + 1;
    END 
  END

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128)) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Field(Self, Name);
  END

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$Base.Count_(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Child(Self, Idx, Obj);
  END

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!CustomListGetBoolean'
    ENGINE UDR;

  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!CustomListGetDouble'
    ENGINE UDR;

  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!CustomListGetInteger'
    ENGINE UDR;

  FUNCTION GetString(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!CustomListGetString'
    ENGINE UDR;

  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!CustomListGetWideString'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$FUNC
AS
BEGIN
  FUNCTION ParseText(Text BLOB SUB_TYPE TEXT, Conv BOOLEAN) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ParseText'
    ENGINE UDR;

  FUNCTION ParseString(String VARCHAR(32765), Conv BOOLEAN) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ParseString'
    ENGINE UDR;

  FUNCTION GenerateText(Obj TY$POINTER, Conv BOOLEAN) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!GenerateText'
    ENGINE UDR;

  FUNCTION GenerateString(Obj TY$POINTER, Conv BOOLEAN) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!GenerateString'
    ENGINE UDR;

  FUNCTION ReadableText(Obj TY$POINTER, Level INTEGER, Conv BOOLEAN)
    RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ReadableText'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$LIST
AS
BEGIN
  PROCEDURE ForEach
    (Self TY$POINTER) RETURNS (Idx Integer, Name VARCHAR(128), Obj TY$POINTER)
  AS
  BEGIN
    FOR
      SELECT Idx, Name, Obj FROM js$custList.ForEach(:Self)
        INTO :Idx, :Name, :Obj
    DO
      SUSPEND;
  END

  FUNCTION Add_(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAdd'
    ENGINE UDR;

  FUNCTION AddBoolean(Self TY$POINTER, Bool BOOLEAN) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddBoolean'
    ENGINE UDR;

  FUNCTION AddDouble(Self TY$POINTER, Dbl DOUBLE PRECISION) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddDouble'
    ENGINE UDR;

  FUNCTION AddInteger(Self TY$POINTER, Int_ INTEGER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddInteger'
    ENGINE UDR;

  FUNCTION AddString(Self TY$POINTER, Str VARCHAR(32765)) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddString'
    ENGINE UDR;

  FUNCTION AddWideString(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddWideString'
    ENGINE UDR;

  FUNCTION Delete_(Self TY$POINTER, Idx Integer) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ListDelete'
    ENGINE UDR;

  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListIndexOfObject'
    ENGINE UDR;

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128)) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Field(Self, Name);
  END

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$custList.Count_(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Child(Self, Idx, Obj);
  END

  FUNCTION Generate(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ListGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ListSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!ListSelfTypeName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$METH
AS
BEGIN
  FUNCTION MethodObjValue(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectMethodObjValue'
    ENGINE UDR;

  FUNCTION MethodName(Self TY$POINTER, Name VARCHAR(128)) RETURNS VARCHAR(128)
    EXTERNAL NAME 'lkjson!ObjectMethodName'
    ENGINE UDR;

  FUNCTION MethodGenerate(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectMethodGenerate'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$NULL
AS
BEGIN
  FUNCTION Value_(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NullValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!NullGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NullSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!NullSelfTypeName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$NUM
AS
BEGIN
  FUNCTION Value_(Self TY$POINTER, Num DOUBLE PRECISION) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!NumberValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER, Num DOUBLE PRECISION) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!NumberGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NumberSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!NumberSelfTypeName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$OBJ
AS
BEGIN
  FUNCTION New_(UseHash BOOLEAN) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectNew'
    ENGINE UDR;

  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectDispose'
    ENGINE UDR;

  PROCEDURE ForEach
    (Self TY$POINTER) RETURNS (Idx INTEGER,  Name VARCHAR(128), Obj TY$POINTER)
  AS
    DECLARE Count_ INTEGER;
  BEGIN
    Idx = 0;
    Count_ = Count_(Self);
    WHILE (Idx < Count_) DO
    BEGIN
      Name = NameOf(Self, Idx);
      Obj = FieldByIndex(Self, Idx);
      SUSPEND;
      Idx = Idx + 1;
    END 
  END

  FUNCTION Add_(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAdd'
    ENGINE UDR;

  FUNCTION AddBoolean(Self TY$POINTER, Name VARCHAR(128), Bool BOOLEAN) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddBoolean'
    ENGINE UDR;

  FUNCTION AddDouble(Self TY$POINTER, Name VARCHAR(128), Dbl DOUBLE PRECISION) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddDouble'
    ENGINE UDR;

  FUNCTION AddInteger(Self TY$POINTER, Name VARCHAR(128), Int_ INTEGER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddInteger'
    ENGINE UDR;

  FUNCTION AddString(Self TY$POINTER, Name VARCHAR(128), Str VARCHAR(32765)) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddString'
    ENGINE UDR;

  FUNCTION AddWideString(Self TY$POINTER, Name VARCHAR(128), WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddWideString'
    ENGINE UDR;

  FUNCTION Delete_(Self TY$POINTER, Idx Integer) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectDelete'
    ENGINE UDR;

  FUNCTION IndexOfName(Self TY$POINTER, Name VARCHAR(128)) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectIndexOfName'
    ENGINE UDR;

  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectIndexOfObject'
    ENGINE UDR;

  FUNCTION Field(Self TY$POINTER, Name VARCHAR(128), Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectField'
    ENGINE UDR;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$custList.Count_(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Child(Self, Idx, Obj);
  END

  FUNCTION Generate(Self TY$POINTER, UseHash BOOLEAN) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!ObjectSelfTypeName'
    ENGINE UDR;

  FUNCTION FieldByIndex(Self TY$POINTER, Idx INTEGER, Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectFieldByIndex'
    ENGINE UDR;

  FUNCTION NameOf(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(128)
    EXTERNAL NAME 'lkjson!ObjectNameOf'
    ENGINE UDR;

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!ObjectGetBoolean'
    ENGINE UDR;

  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!ObjectGetDouble'
    ENGINE UDR;

  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectGetInteger'
    ENGINE UDR;

  FUNCTION GetString(Self TY$POINTER, Idx INTEGER) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!ObjectGetString'
    ENGINE UDR;

  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ObjectGetWideString'
    ENGINE UDR;

  FUNCTION GetBooleanByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!ObjectGetBooleanByName'
    ENGINE UDR;

  FUNCTION GetDoubleByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!ObjectGetDoubleByName'
    ENGINE UDR;

  FUNCTION GetIntegerByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectGetIntegerByName'
    ENGINE UDR;

  FUNCTION GetStringByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!ObjectGetStringByName'
    ENGINE UDR;

  FUNCTION GetWideStringByName(Self TY$POINTER, Name VARCHAR(128)) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ObjectGetWideStringByName'
    ENGINE UDR;
END^


RECREATE PACKAGE BODY JS$PTR
AS
BEGIN

  FUNCTION New_(UsePtr CHAR(3), UseHash BOOLEAN) RETURNS TY$POINTER
  AS
    DECLARE js TY$POINTER;
  BEGIN
    js = NULL;
    IF (UPPER(UsePtr) = 'TRA') THEN
    BEGIN
      IF (EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_TRA_COMMIT' AND
                    t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
          AND
          EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_TRA_ROLLBACK' AND
                    t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
         ) THEN
      BEGIN
        js = CAST(RDB$GET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION') AS TY$POINTER);
        IF (js IS NULL) THEN
        BEGIN
          js = js$Obj.New_(TRUE);
          RDB$SET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION', js);
        END
      END
    END ELSE
    IF (UPPER(UsePtr) = 'ATT') THEN
    BEGIN
      IF (EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_ATT_DISCONNECT'
                    AND t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
         ) THEN
      BEGIN
        js = CAST(RDB$GET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT') AS TY$POINTER);
        IF (js IS NULL) THEN
        BEGIN
          js = js$Obj.New_(TRUE);
          RDB$SET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT', js);
        END
      END
    END
    RETURN js;
  END

  FUNCTION Dispose(UsePtr CHAR(3)) RETURNS SMALLINT
  AS
    DECLARE js TY$POINTER;
  BEGIN
    IF (UPPER(UsePtr) = 'TRA') THEN js = tra(); ELSE
    IF (UPPER(UsePtr) = 'ATT') THEN js = att(); ELSE
      js = NULL;
    IF (js IS NOT NULL)  THEN
    BEGIN
      IF (UPPER(UsePtr) = 'TRA') THEN RDB$SET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION', NULL);
      IF (UPPER(UsePtr) = 'ATT') THEN RDB$SET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT', NULL);
      RETURN js$Obj.Dispose(js);
    END
    ELSE
      RETURN NULL;
  END

  FUNCTION Tra RETURNS TY$POINTER
  AS
  BEGIN
    RETURN
      CAST(RDB$GET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION') AS TY$POINTER);
  END

  FUNCTION Att RETURNS TY$POINTER
  AS
  BEGIN
    RETURN
      CAST(RDB$GET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT') AS TY$POINTER);
  END

  FUNCTION isNull(jsPtr TY$POINTER) RETURNS BOOLEAN
  AS
    DECLARE nullPtr TY$POINTER = x'0000000000000000';
  BEGIN
    RETURN
      CASE
         WHEN jsPtr IS NULL OR jsPtr = nullPtr THEN TRUE
           ELSE FALSE
      END;
  END

END^


RECREATE PACKAGE BODY JS$STR
AS
BEGIN
  FUNCTION Value_(Self TY$POINTER, Str VARCHAR(32765)) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!StringValue'
    ENGINE UDR;

  FUNCTION WideValue_(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!StringWideValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER, Str VARCHAR(32765)) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!StringGenerate'
    ENGINE UDR;

  FUNCTION WideGenerate(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!StringWideGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!StringSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER) RETURNS VARCHAR(32)
    EXTERNAL NAME 'lkjson!StringSelfTypeName'
    ENGINE UDR;
END^



SET TERM ; ^



/******************************************************************************/
/***                                Triggers                                ***/
/******************************************************************************/



SET TERM ^ ;



/******************************************************************************/
/***                        Database event triggers                         ***/
/******************************************************************************/



/* Trigger: JS$PTR_ATT_DISCONNECT */
CREATE OR ALTER TRIGGER JS$PTR_ATT_DISCONNECT
ACTIVE ON DISCONNECT POSITION 32012
AS
BEGIN
  js$Ptr.Dispose('Att');
END
^

/* Trigger: JS$PTR_TRA_COMMIT */
CREATE OR ALTER TRIGGER JS$PTR_TRA_COMMIT
ACTIVE ON TRANSACTION COMMIT POSITION 32010
AS
BEGIN
  js$Ptr.Dispose('Tra');
END
^

/* Trigger: JS$PTR_TRA_ROLLBACK */
CREATE OR ALTER TRIGGER JS$PTR_TRA_ROLLBACK
ACTIVE ON TRANSACTION ROLLBACK POSITION 32011
AS
BEGIN
  js$Ptr.Dispose('Tra');
END
^
SET TERM ; ^
