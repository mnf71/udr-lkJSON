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



/******************************************************************************/
/***                               Privileges                               ***/
/******************************************************************************/



/******************************************************************************/
/***                             DDL privileges                             ***/
/******************************************************************************/

