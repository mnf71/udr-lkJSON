EXECUTE BLOCK RETURNS (
  i INTEGER,
  j INTEGER,
  n VARCHAR(128),
  v VARCHAR(32)
)
AS
  /*
     jsBase jsNumber jsString jsBoolean jsNull jsList jsObject
     0      1        2        3         4      5      6
  */
  DECLARE PROCEDURE Value_ (
    jsPtr TY$POINTER
  ) RETURNS (
    v VARCHAR(32)
  )
  AS
  BEGIN
    v = NULL;
    IF (js$Base.SelfType(jsPtr) = 0) THEN
    BEGIN
      v = NULL;
      SUSPEND;
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 1) THEN
    BEGIN
      v = CAST(js$Num.Value_(jsPtr) AS VARCHAR(32));
      SUSPEND;
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 2) THEN
    BEGIN
      v = js$Str.Value_(jsPtr);
      SUSPEND;
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 3) THEN
    BEGIN
      v = CAST(js$Bool.Value_(jsPtr) AS VARCHAR(32));
      SUSPEND;
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 4) THEN
    BEGIN
      v = NULL;
      SUSPEND;
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 5) THEN
    BEGIN
    END ELSE
    IF (js$Base.SelfType(jsPtr) = 6) THEN
    BEGIN
    END
  END
BEGIN
  /*
     After rec_load.sql
  */
  FOR
    SELECT j.* FROM js$Obj.ForEach(js$Ptr.Att()) j AS CURSOR c0
  DO
  BEGIN
    i = c0.Idx;
    j = 0;
    n = c0.Name;
    v = NULL;
    IF (js$Base.SelfType(c0.Obj) = 5) THEN
    BEGIN
      SUSPEND;
      FOR
        SELECT r.* FROM js$List.ForEach(c0.Obj) r AS CURSOR cL
      DO
      BEGIN
        j = cL.Idx;
        n = cL.Name;
        EXECUTE PROCEDURE Value_(cL.Obj) RETURNING_VALUES :v;
        SUSPEND;
      END
    END ELSE
    IF (js$Base.SelfType(c0.Obj) = 6) THEN
    BEGIN
      SUSPEND;
      FOR
        SELECT r.* FROM js$Obj.ForEach(c0.Obj) r AS CURSOR cR
      DO
      BEGIN
        j = cR.Idx;
        n = cR.Name;
        EXECUTE PROCEDURE Value_(cR.Obj) RETURNING_VALUES :v;
        SUSPEND;
      END
    END
    ELSE
    BEGIN
      EXECUTE PROCEDURE Value_(c0.Obj) RETURNING_VALUES :v;
      SUSPEND;
    END
  END
END




