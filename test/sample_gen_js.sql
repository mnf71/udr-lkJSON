EXECUTE BLOCK
AS
  DECLARE jsRec TY$POINTER;
  DECLARE jsLst TY$POINTER;
  DECLARE i INTEGER;
BEGIN
  js$Ptr.New_('Att'); -- auto-Dispose on Disconnect (!)
  -- js$Ptr.New_('Tra'); -- auto-Dispose on Commit or Rollabck transaction
  js$Obj.AddInteger(js$Ptr.Att(), 'Records', 0);
  i = 0;
  FOR
    SELECT * FROM Sample AS CURSOR cS
  DO
  BEGIN
    i = i + 1;
    jsRec = js$Obj.New_();
    js$Obj.AddInteger(jsRec, 'Integer', cS.I32);
    js$Obj.AddDouble(jsRec, 'Double', cS.Dbl);
    js$Obj.AddString(jsRec, 'String', cS.Str);
    js$Obj.AddString(jsRec, 'DateTime', cS.DMY);
    js$Obj.Add_ -- jsRec assigned js$Att, no call Dispose (!)
      (js$Ptr.Att(), CAST(cS.Rec AS VARCHAR(10)), jsRec);
  END
  js$Num.Value_(js$Obj.Field(js$Ptr.Att(), 'Records'), i);
  jsLst = js$List.Generate();
  js$List.AddInteger(jsLst, EXTRACT(YEAR FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(MONTH FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(DAY FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(HOUR FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(MINUTE FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(SECOND FROM CURRENT_TIMESTAMP));
  js$List.AddInteger(jsLst, EXTRACT(MILLISECOND FROM CURRENT_TIMESTAMP));
  js$Obj.AddBoolean(js$Ptr.Att(), 'Status', True);
  js$Obj.Add_(js$Ptr.Att(), 'Stamp', jsLst);
END

