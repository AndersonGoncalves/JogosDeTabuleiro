unit uPeca;

interface

uses
  System.SysUtils, uITabuleiro, uCor;

type
  TPeca = class(TInterfacedObject, IPeca)
  private
    FTabuleiro           : ITabuleiro;
    FCor                 : TCor;
    FPosicao             : IPosicao;
    FQuantidadeMovimento : Integer;
    FMovimentosPossiveis : TArrayOfArrayBoolean;
    FNomeDaPeca          : String;
  protected
    function GetPosicao: IPosicao;
    procedure SetPosicao(const Value: IPosicao);
    function GetTabuleiro: ITabuleiro;
    function GetCor: TCor;
    function GetQuantidadeMovimento: Integer;
    procedure SetQuantidadeMovimento(const Value: Integer);
    function GetMovimentosPossiveis: TArrayOfArrayBoolean;
    procedure SetMovimentosPossiveis(const Value: TArrayOfArrayBoolean);
    function GetNomeDaPeca: String;
    procedure SetNomeDaPeca(const Value: String);
    function PodeMover(aPosicao: IPosicao): Boolean;
  public
    property Tabuleiro           : ITabuleiro           read GetTabuleiro;
    property Cor                 : TCor                 read GetCor;
    property Posicao             : IPosicao             read GetPosicao             write SetPosicao;
    property QuantidadeMovimento : Integer              read GetQuantidadeMovimento write SetQuantidadeMovimento;
    property MovimentosPossiveis : TArrayOfArrayBoolean read GetMovimentosPossiveis write SetMovimentosPossiveis;
    property NomeDaPeca          : String               read GetNomeDaPeca          write SetNomeDaPeca;
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor; aQuantidadeMovimento: Integer = 0); overload;
    procedure IncrementarQuantidadeMovimento;
    procedure DecrementarQuantidadeMovimento;
    function MovimentoPossivel(aLinha, aColuna: Integer): Boolean;
    function ExisteMovimentoPossivel: Boolean;
    function PodeMoverPara(aPosicao: IPosicao): Boolean;
    function SetMovimentos(aValue: Integer): TPeca; deprecated;
    procedure SalvarMovimentosPossiveis; virtual;
  end;

implementation

{ TPeca }

constructor TPeca.Create(aTabuleiro: ITabuleiro; aCor: TCor; aQuantidadeMovimento: Integer = 0);
begin
  FTabuleiro           := aTabuleiro;
  FCor                 := aCor;
  FPosicao             := nil;
  FQuantidadeMovimento := aQuantidadeMovimento;
  FNomedaPeca          := EmptyStr;
  SetLength(FMovimentosPossiveis, aTabuleiro.Linhas, aTabuleiro.Colunas);
end;

procedure TPeca.IncrementarQuantidadeMovimento;
begin
  Inc(FQuantidadeMovimento);
end;

procedure TPeca.DecrementarQuantidadeMovimento;
begin
  Dec(FQuantidadeMovimento);
end;

function TPeca.MovimentoPossivel(aLinha, aColuna: Integer): Boolean;
begin
  Result := FMovimentosPossiveis[aLinha, aColuna];
end;

function TPeca.ExisteMovimentoPossivel: Boolean;
begin
  Result := False;
  for var i: Integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: Integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FMovimentosPossiveis[i, j] then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TPeca.GetCor: TCor;
begin
  Result := FCor;
end;

function TPeca.GetMovimentosPossiveis: TArrayOfArrayBoolean;
begin
  Result := FMovimentosPossiveis;
end;

function TPeca.GetNomeDaPeca: String;
begin
  Result := FNomeDaPeca;
end;

function TPeca.GetPosicao: IPosicao;
begin
  Result := FPosicao;
end;

function TPeca.GetQuantidadeMovimento: Integer;
begin
  Result := FQuantidadeMovimento;
end;

function TPeca.GetTabuleiro: ITabuleiro;
begin
  Result := FTabuleiro;
end;

procedure TPeca.SalvarMovimentosPossiveis;
begin
  for var i: Integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: Integer := 0 to FTabuleiro.Colunas - 1 do
      FMovimentosPossiveis[i, j] := False;
  end;
end;

procedure TPeca.SetMovimentosPossiveis(const Value: TArrayOfArrayBoolean);
begin
  FMovimentosPossiveis := Value;
end;

procedure TPeca.SetNomeDaPeca(const Value: String);
begin
  FNomeDaPeca := Value;
end;

procedure TPeca.SetPosicao(const Value: IPosicao);
begin
  FPosicao := Value;
end;

procedure TPeca.SetQuantidadeMovimento(const Value: Integer);
begin
  FQuantidadeMovimento := Value;
end;

function TPeca.PodeMover(aPosicao: IPosicao): Boolean;
var
  peca: IPeca;
begin
  peca   := FTabuleiro.GetPeca(aPosicao);
  Result := (peca = nil) or (peca.Cor <> FCor);
end;

function TPeca.PodeMoverPara(aPosicao: IPosicao): Boolean;
begin
  Result := FMovimentosPossiveis[aPosicao.Linha, aPosicao.Coluna];
end;

function TPeca.SetMovimentos(aValue: Integer): TPeca;
begin
  FQuantidadeMovimento := aValue;
  Result := Self;
end;

end.
