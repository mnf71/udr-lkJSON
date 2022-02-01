CREATE OR ALTER PROCEDURE JS_A
RETURNS (
    S VARCHAR(32765))
AS
  DECLARE jsRec TY$POINTER;
  DECLARE jsLst TY$POINTER;
  DECLARE p TY$POINTER;
BEGIN
  js$Ptr.New_('Tra');
  js$Obj.AddInteger(js$Ptr.Tra(), 'Records', 0);

  jsLst = js$List.Generate();
  js$List.AddInteger(jsLst, EXTRACT(YEAR FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(MONTH FROM CURRENT_TIMESTAMP));
  js$Obj.Add_(js$Ptr.Tra(), 'Stamp', jsLst);

  jsRec = js$Obj.Field(js$Ptr.Tra(), 'Records');
  js$Num.Value_(jsRec, 10);

  -- call parent
  p = js$Obj.Parent(jsRec);
  s = js$Meth.MethodName(p);
  SUSPEND;

  p = js$Meth.Parent(p);
  js$Obj.AddString(p, 'Parent', 'Ok');

  s = js$Func.ReadableText(js$Ptr.Tra());
  SUSPEND;
END