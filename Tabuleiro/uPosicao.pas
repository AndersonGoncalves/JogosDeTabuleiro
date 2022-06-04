unit uPosicao;

interface

uses
  uITabuleiro;

type
  TPosicao = class(TInterfacedObject, IPosicao)
  private
    FLinha : Integer;
    FColuna: Integer;
  protected
    function GetColuna: Integer;
    function GetLinha: Integer;
    procedure SetColuna(const Value: Integer);
    procedure SetLinha(const Value: Integer);
  public
    property Linha : Integer read GetLinha  write SetLinha;
    property Coluna: Integer read GetColuna write SetColuna;
    constructor Create(aLinha, aColuna: Integer); overload;
    procedure DefinirValores(aLinha, aColuna: Integer);
  end;

implementation

{ TPosicao }

constructor TPosicao.Create(aLinha, aColuna: Integer);
begin
  DefinirValores(aLinha, aColuna);
end;

procedure TPosicao.DefinirValores(aLinha, aColuna: Integer);
begin
  FLinha  := aLinha;
  FColuna := aColuna;
end;

function TPosicao.GetColuna: Integer;
begin
  Result := FColuna;
end;

function TPosicao.GetLinha: Integer;
begin
  Result := FLinha;
end;

procedure TPosicao.SetColuna(const Value: Integer);
begin
  FColuna := Value;
end;

procedure TPosicao.SetLinha(const Value: Integer);
begin
  FLinha := Value;
end;

end.
