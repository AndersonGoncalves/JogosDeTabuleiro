unit uSingleton;

interface

type
  TSingleton<T: class, constructor> = class
  protected
    class var FInstance: T;
  public
    class function GetInstance: T;
    class procedure ReleaseInstance;
  end;

implementation

{ TSingleton<T> }

class function TSingleton<T>.GetInstance: T;
begin
  if not Assigned(FInstance) then
    FInstance := T.Create();
  Result := FInstance;
end;

class procedure TSingleton<T>.ReleaseInstance;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

end.
