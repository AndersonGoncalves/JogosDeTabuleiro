unit uPartida;

interface

uses
  System.SysUtils, uIPartida, uITabuleiro, uTabuleiro, uSingleton, uCor, uPosicaoXadrez,
  uPosicao, uBispo, uCavalo, uPeao, uRainha, uRei, uTorre, uXadrezException;

type
  TPartida = class(TInterfacedObject, IPartida)
  private
    FTabuleiro           : ITabuleiro;
    FTurno               : Integer;
    FJogadorAtual        : TCor;
    FTerminada           : Boolean;
    FPretasCapturadas    : IArrayOfCapturadas;
    FBrancasCapturadas   : IArrayOfCapturadas;
    FXeque               : Boolean;
    FVulneravelEnpassant : IPeca;
    function ExecutarMovimento(aOrigem, aDestino: IPosicao): IPeca;
    procedure DesfazMovimento(aOrigem, aDestino: IPosicao; aPecaCapturada: IPeca);
    procedure ColocarPecasNoTabuleiro;
    procedure MudarJogador;
    function Adversario(aCor: TCor): TCor;
    function Rei(aCor: TCor): IPeca;
    function ReiEstaEmXeque(aCor: TCor): Boolean;
    function TesteXequeMate(aCor: TCor): Boolean;
    procedure LimparPeoesVulneraveisEnPassant;
    procedure SetReiEmXeque(aCor: TCor);
    procedure LimparReisEmXeque;
  protected
    function GetTabuleiro: ITabuleiro;
    procedure SetTabuleiro(const Value: ITabuleiro);
    function GetTurno: Integer;
    procedure SetTurno(const Value: Integer);
    function GetJogadorAtual: TCor;
    procedure SetJogadorAtual(const Value: TCor);
    function GetTerminada: boolean;
    procedure SetTerminada(const Value: Boolean);
    function GetBrancasCapturadas: IArrayOfCapturadas;
    procedure SetBrancasCapturadas(const Value: IArrayOfCapturadas);
    function GetPretasCapturadas: IArrayOfCapturadas;
    procedure SetPretasCapturadas(const Value: IArrayOfCapturadas);
    function GetXeque: Boolean;
    procedure SetXeque(const Value: Boolean);
    function GetVulneravelEnpassant: IPeca;
    procedure SetVulneravelEnpassant(const Value: IPeca);
    function GetEmpate: Boolean;
  public
    property Tabuleiro           : ITabuleiro         read GetTabuleiro           write SetTabuleiro;
    property Turno               : Integer            read GetTurno               write SetTurno;
    property JogadorAtual        : TCor               read GetJogadorAtual        write SetJogadorAtual;
    property Terminada           : Boolean            read GetTerminada           write SetTerminada;
    property PretasCapturadas    : IArrayOfCapturadas read GetPretasCapturadas    write SetPretasCapturadas;
    property BrancasCapturadas   : IArrayOfCapturadas read GetBrancasCapturadas   write SetBrancasCapturadas;
    property Xeque               : Boolean            read GetXeque               write SetXeque;
    property VulneravelEnpassant : IPeca              read GetVulneravelEnpassant write SetVulneravelEnpassant;
    property Empate              : Boolean            read GetEmpate;
    constructor Create;
    destructor Destroy; override;
    procedure ColocarNovaPeca(aColuna: char; aLinha: Integer; aPeca: IPeca);
    Procedure RealizarJogada(aOrigem, aDestino: IPosicao);
    procedure ValidarPosicaoDeOrigem(aOrigem: IPosicao);
    procedure ValidarPosicaoDeDestino(aOrigem, aDestino: IPosicao);
    function CorDoJogadorAtual: string;
    procedure RetirarTodasPecasDoTabuleiro;
    procedure Reiniciar;
  end;

  TPartidaSingleton = TSingleton<TPartida>;

implementation

{ TPartida }

constructor TPartida.Create;
begin
  Reiniciar;
end;

destructor TPartida.Destroy;
begin
  FTabuleiro.Release;
  inherited;
end;

function TPartida.ExecutarMovimento(aOrigem, aDestino: IPosicao): IPeca;
var
  pecaAuxiliar, pecaRetirada: IPeca;

  procedure CapturarBranca(aPeca: IPeca);
  begin
    for var i: integer := 0 to Length(FBrancasCapturadas) - 1 do
    begin
      if FBrancasCapturadas[i] = nil then
      begin
        FBrancasCapturadas[i] := aPeca;
        Break;
      end;
    end;
  end;

  procedure CapturarPreta(aPeca: IPeca);
  begin
    for var i: integer := 0 to Length(FPretasCapturadas) - 1 do
    begin
      if FPretasCapturadas[i] = nil then
      begin
        FPretasCapturadas[i] := aPeca;
        Break;
      end;
    end;
  end;

  procedure ExecutaRoquePequeno(aOrigem: IPosicao);
  var
    OrigemTorre, DestinoTorre: IPosicao;
    Torre: IPeca;
  begin
    OrigemTorre  := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna + 3);
    DestinoTorre := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna + 1);
    Torre        := FTabuleiro.RetirarPeca(OrigemTorre.Linha, OrigemTorre.Coluna);
    Torre.IncrementarQuantidadeMovimento;
    FTabuleiro.ColocarPeca(Torre, DestinoTorre);
  end;

  procedure ExecutaRoqueGrande(aOrigem: IPosicao);
  var
    OrigemTorre, DestinoTorre: IPosicao;
    Torre: IPeca;
  begin
    OrigemTorre  := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna - 4);
    DestinoTorre := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna - 1);
    Torre        := FTabuleiro.RetirarPeca(OrigemTorre.Linha, OrigemTorre.Coluna);
    Torre.IncrementarQuantidadeMovimento;
    FTabuleiro.ColocarPeca(Torre, DestinoTorre);
  end;

  procedure ExecutaEnPassant(aPeca, aPecaCapturada: IPeca; aOrigem, aDestino: IPosicao);
  var
    aPosicaoPeca: IPosicao;
  begin
    if (aOrigem.Coluna <> aDestino.Coluna) and (aPecaCapturada = nil) then
    begin
      aPosicaoPeca := TPosicao.Create;
      try
        if (aPeca.Cor = Branca) then
          aPosicaoPeca.DefinirValores(aDestino.Linha + 1, aDestino.Coluna)
        else
          aPosicaoPeca.DefinirValores(aDestino.Linha - 1, aDestino.Coluna);

        aPecaCapturada := FTabuleiro.RetirarPeca(aPosicaoPeca.Linha, aPosicaoPeca.Coluna);

        if aPecaCapturada.Cor = Branca then
          CapturarBranca(aPecaCapturada)
        else if aPecaCapturada.Cor = Preta then
          CapturarPreta(aPecaCapturada);
      finally
        aPosicaoPeca := nil;
      end;
    end;
  end;

begin
  pecaRetirada := FTabuleiro.RetirarPeca(aDestino.Linha, aDestino.Coluna);
  Result       := pecaRetirada;

  if pecaRetirada <> nil then
  begin
    if pecaRetirada.Cor = Branca then
      CapturarBranca(pecaRetirada)
    else if pecaRetirada.Cor = Preta then
      CapturarPreta(pecaRetirada);
  end;

  pecaAuxiliar := FTabuleiro.RetirarPeca(aOrigem.Linha, aOrigem.Coluna);
  pecaAuxiliar.IncrementarQuantidadeMovimento;
  FTabuleiro.ColocarPeca(pecaAuxiliar, aDestino);

  if (pecaAuxiliar is TRei) and (aDestino.Coluna = aOrigem.Coluna + 2) then
    ExecutaRoquePequeno(aOrigem);

  if (pecaAuxiliar is TRei) and (aDestino.Coluna = aOrigem.Coluna - 2) then
    ExecutaRoqueGrande(aOrigem);

  if (pecaAuxiliar is TPeao) then
    ExecutaEnPassant(pecaAuxiliar, pecaRetirada, aOrigem, aDestino);
end;

procedure TPartida.DesfazMovimento(aOrigem, aDestino: IPosicao; aPecaCapturada: IPeca);
var
  aPecaDestino: IPeca;

  procedure RemoverPecaCapturada;
  begin
    if aPecaCapturada.Cor = Branca then
    begin
      for var i: integer := 0 to Length(FBrancasCapturadas) - 1 do
      begin
        if FBrancasCapturadas[i] = aPecaCapturada then
        begin
          FBrancasCapturadas[i] := nil;
          Break;
        end;
      end;
    end
    else if aPecaCapturada.Cor = Preta then
    begin
      for var i: integer := 0 to Length(FPretasCapturadas) - 1 do
      begin
        if FPretasCapturadas[i] = aPecaCapturada then
        begin
          FPretasCapturadas[i] := nil;
          Break;
        end;
      end;
    end;
  end;

  procedure DesfazRoquePequeno(aOrigem: IPosicao);
  var
    OrigemTorre, DestinoTorre: IPosicao;
    Torre: IPeca;
  begin
    OrigemTorre  := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna + 3);
    DestinoTorre := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna + 1);
    Torre        := FTabuleiro.RetirarPeca(DestinoTorre.Linha, DestinoTorre.Coluna);
    Torre.DecrementarQuantidadeMovimento;
    FTabuleiro.ColocarPeca(Torre, OrigemTorre);
  end;

  procedure DesfazRoqueGrande(aOrigem: IPosicao);
  var
    OrigemTorre, DestinoTorre: IPosicao;
    Torre: IPeca;
  begin
    OrigemTorre  := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna - 4);
    DestinoTorre := TPosicao.Create(aOrigem.Linha, aOrigem.Coluna - 1);
    Torre        := FTabuleiro.RetirarPeca(DestinoTorre.Linha, DestinoTorre.Coluna);
    Torre.DecrementarQuantidadeMovimento;
    FTabuleiro.ColocarPeca(Torre, OrigemTorre);
  end;

  procedure DesfazEnPassant(aPeca, aPecaCapturada: IPeca; aOrigem, aDestino: IPosicao);
  var
    aPosicaoPeca: IPosicao;
    peao: IPeca;
  begin
    if (aOrigem.Coluna <> aDestino.Coluna) and (aPecaCapturada = FVulneravelEnpassant) then
    begin
      peao := Tabuleiro.RetirarPeca(aDestino.Linha, aDestino.Coluna);
      try
        if aPeca.Cor = Branca then
          aPosicaoPeca.DefinirValores(3, aDestino.Coluna)
        else
          aPosicaoPeca.DefinirValores(4, aDestino.Coluna);
        FTabuleiro.ColocarPeca(peao, aPosicaoPeca);
      finally
        aPosicaoPeca := nil;
      end;
    end;
  end;

begin
  aPecaDestino := FTabuleiro.RetirarPeca(aDestino.Linha, aDestino.Coluna);
  aPecaDestino.DecrementarQuantidadeMovimento;
  if aPecaCapturada <> nil then
  begin
    FTabuleiro.ColocarPeca(aPecaCapturada, aDestino);
    RemoverPecaCapturada;
  end;
  FTabuleiro.ColocarPeca(aPecaDestino, aOrigem);

  if (aPecaDestino is TRei) and (aDestino.Coluna = aOrigem.Coluna + 2) then
    DesfazRoquePequeno(aOrigem);

  if (aPecaDestino is TRei) and (aDestino.Coluna = aOrigem.Coluna - 2) then
    DesfazRoqueGrande(aOrigem);

  if (aPecaDestino is TPeao) then
    DesfazEnPassant(aPecaDestino, aPecaCapturada, aOrigem, aDestino);
end;

procedure TPartida.MudarJogador;
begin
  if FJogadorAtual = Branca then
    FJogadorAtual := Preta
  else
    FJogadorAtual := Branca;
end;

function TPartida.Adversario(aCor: TCor): TCor;
begin
  if aCor = Branca then
    Result := Preta
  else
    Result := Branca;
end;

function TPartida.GetBrancasCapturadas: IArrayOfCapturadas;
begin
  Result := FBrancasCapturadas;
end;

function TPartida.GetEmpate: Boolean;
begin
  //TODO:
  Result := False;
end;

function TPartida.GetJogadorAtual: TCor;
begin
  Result := FJogadorAtual;
end;

function TPartida.GetPretasCapturadas: IArrayOfCapturadas;
begin
  Result := FPretasCapturadas;
end;

function TPartida.GetTabuleiro: ITabuleiro;
begin
  Result := FTabuleiro;
end;

function TPartida.GetTerminada: Boolean;
begin
  Result := FTerminada;
end;

function TPartida.GetTurno: Integer;
begin
  Result := FTurno;
end;

function TPartida.GetVulneravelEnpassant: IPeca;
begin
  Result := FVulneravelEnpassant;
end;

function TPartida.GetXeque: Boolean;
begin
  Result := FXeque;
end;

procedure TPartida.SetBrancasCapturadas(const Value: IArrayOfCapturadas);
begin
  FBrancasCapturadas := Value;
end;

procedure TPartida.SetJogadorAtual(const Value: TCor);
begin
  FJogadorAtual := Value;
end;

procedure TPartida.SetPretasCapturadas(const Value: IArrayOfCapturadas);
begin
  FPretasCapturadas := Value;
end;

procedure TPartida.SetTabuleiro(const Value: ITabuleiro);
begin
  FTabuleiro := Value;
end;

procedure TPartida.SetTerminada(const Value: Boolean);
begin
  FTerminada := Value;
end;

procedure TPartida.SetTurno(const Value: Integer);
begin
  FTurno := Value;
end;

procedure TPartida.SetVulneravelEnpassant(const Value: IPeca);
begin
  FVulneravelEnpassant := Value;
end;

procedure TPartida.SetReiEmXeque(aCor: TCor);
begin
  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas[i, j] <> nil then
      begin
        if (FTabuleiro.Pecas[i, j] is TRei) and (FTabuleiro.Pecas[i, j].Cor = aCor) then
        begin
          TRei(FTabuleiro.Pecas[i, j]).ReiEmXeque := True;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TPartida.SetXeque(const Value: Boolean);
begin
  FXeque := Value;
end;

function TPartida.TesteXequeMate(aCor: TCor): Boolean;
var
  ReiEmXeque: Boolean;
  pecaCapturada: IPeca;
  origem, destino: IPosicao;
begin
  Result := False;
  if ReiEstaEmXeque(aCor) then
  begin
    for var i: integer := 0 to FTabuleiro.Linhas - 1 do
    begin
      for var j: integer := 0 to FTabuleiro.Colunas - 1 do
      begin
        if FTabuleiro.Pecas[i, j] <> nil then
        begin
          if (FTabuleiro.Pecas[i, j].Cor = aCor) then
          begin
            FTabuleiro.Pecas[i, j].SalvarMovimentosPossiveis;
            if FTabuleiro.Pecas[i, j].ExisteMovimentoPossivel then
            begin
              for var k: integer := 0 to FTabuleiro.Linhas - 1 do
              begin
                for var l: integer := 0 to FTabuleiro.Colunas - 1 do
                begin
                  if FTabuleiro.Pecas[i, j].MovimentoPossivel(k, l) then
                  begin
                    origem        := FTabuleiro.Pecas[i, j].Posicao;
                    destino       := TPosicao.Create(k, l);
                    pecaCapturada := ExecutarMovimento(origem, destino);
                    ReiEmXeque    := ReiEstaEmXeque(aCor);
                    DesfazMovimento(origem, destino, pecaCapturada);
                    if ReiEmXeque then
                      Result := True
                    else
                    begin
                      Result := False;
                      Exit;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPartida.LimparPeoesVulneraveisEnPassant;
begin
  FVulneravelEnpassant := nil;
  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas[i, j] <> nil then
      begin
        if (FTabuleiro.Pecas[i, j] is TPeao) then
          TPeao(FTabuleiro.Pecas[i, j]).VulneravelEnpassant := False;
      end;
    end;
  end;
end;

procedure TPartida.LimparReisEmXeque;
begin
  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas[i, j] <> nil then
      begin
        if (FTabuleiro.Pecas[i, j] is TRei) then
          TRei(FTabuleiro.Pecas[i, j]).ReiEmXeque := False;
      end;
    end;
  end;
end;

procedure TPartida.ColocarPecasNoTabuleiro;
begin
  ColocarNovaPeca('A', 1, TTorre.Create(FTabuleiro, Branca));
  ColocarNovaPeca('B', 1, TCavalo.Create(FTabuleiro, Branca));
  ColocarNovaPeca('C', 1, TBispo.Create(FTabuleiro, Branca));
  ColocarNovaPeca('D', 1, TRainha.Create(FTabuleiro, Branca));
  ColocarNovaPeca('E', 1, TRei.Create(FTabuleiro, Branca));
  ColocarNovaPeca('F', 1, TBispo.Create(FTabuleiro, Branca));
  ColocarNovaPeca('G', 1, TCavalo.Create(FTabuleiro, Branca));
  ColocarNovaPeca('H', 1, TTorre.Create(FTabuleiro, Branca));
  ColocarNovaPeca('A', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('B', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('C', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('D', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('E', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('F', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('G', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('H', 2, TPeao.Create(FTabuleiro, Branca));
  ColocarNovaPeca('A', 8, TTorre.Create(FTabuleiro, Preta));
  ColocarNovaPeca('B', 8, TCavalo.Create(FTabuleiro, Preta));
  ColocarNovaPeca('C', 8, TBispo.Create(FTabuleiro, Preta));
  ColocarNovaPeca('D', 8, TRainha.Create(FTabuleiro, Preta));
  ColocarNovaPeca('E', 8, TRei.Create(FTabuleiro, Preta));
  ColocarNovaPeca('F', 8, TBispo.Create(FTabuleiro, Preta));
  ColocarNovaPeca('G', 8, TCavalo.Create(FTabuleiro, Preta));
  ColocarNovaPeca('H', 8, TTorre.Create(FTabuleiro, Preta));
  ColocarNovaPeca('A', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('B', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('C', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('D', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('E', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('F', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('G', 7, TPeao.Create(FTabuleiro, Preta));
  ColocarNovaPeca('H', 7, TPeao.Create(FTabuleiro, Preta));
end;

procedure TPartida.ColocarNovaPeca(aColuna: char; aLinha: Integer; aPeca: IPeca);
var
  PosicaoXadrez: TPosicaoXadrez;
begin
  try
    PosicaoXadrez := TPosicaoXadrez.Create(aColuna, aLinha);
    FTabuleiro.ColocarPeca(aPeca, PosicaoXadrez.ToPosicao);
  finally
    if Assigned(PosicaoXadrez) then
      FreeAndNil(PosicaoXadrez);
  end;
end;

procedure TPartida.RealizarJogada(aOrigem, aDestino: IPosicao);
var
  pecaCapturada, pecaAux: IPeca;

  procedure VerificaPromocaoDoPeao(aPeca: IPeca; aDestinoPeca: IPosicao);
  begin
    if ((aPeca.Cor = Branca) and (aDestinoPeca.Linha = 0)) or ((aPeca.Cor = Preta) and (aDestinoPeca.Linha = 7)) then
    begin
      aPeca := FTabuleiro.RetirarPeca(aDestinoPeca.Linha, aDestinoPeca.Coluna);
      FTabuleiro.ColocarPeca(TRainha.Create(FTabuleiro, aPeca.Cor), aDestinoPeca);
    end;
  end;

begin
  Tabuleiro.GetPeca(aOrigem).SalvarMovimentosPossiveis;
  ValidarPosicaoDeOrigem(aOrigem);
  ValidarPosicaoDeDestino(aOrigem, aDestino);

  pecaCapturada := ExecutarMovimento(aOrigem, aDestino);

  if (ReiEstaEmXeque(FJogadorAtual)) then
  begin
    DesfazMovimento(aOrigem, aDestino, pecaCapturada);
    raise XadrezException.Create('Você não pode se colocar em xeque!');
  end;

  pecaAux := FTabuleiro.GetPeca(aDestino);
  if (pecaAux is TPeao) then
    VerificaPromocaoDoPeao(pecaAux, aDestino);

  LimparReisEmXeque;
  FXeque := ReiEstaEmXeque(Adversario(FJogadorAtual));

  if FXeque then
    SetReiEmXeque(Adversario(FJogadorAtual));

  FTerminada := TesteXequeMate(Adversario(FJogadorAtual)) or Empate;
  if not FTerminada then
  begin
    Inc(FTurno);
    MudarJogador;
  end;

  LimparPeoesVulneraveisEnPassant;
  if (Tabuleiro.GetPeca(aDestino) is TPeao) and ((aDestino.Linha = aOrigem.Linha - 2) or (aDestino.Linha = aOrigem.Linha + 2)) then
  begin
    FVulneravelEnpassant := Tabuleiro.GetPeca(aDestino);
    TPeao(Tabuleiro.GetPeca(aDestino)).VulneravelEnpassant := True;
  end;
end;

function TPartida.Rei(aCor: TCor): IPeca;
begin
  Result := nil;
  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas[i, j] <> nil then
      begin
        if (FTabuleiro.Pecas[i, j] is TRei) and (FTabuleiro.Pecas[i, j].Cor = aCor) then
        begin
          Result := FTabuleiro.Pecas[i, j];
          Break;
        end;
      end;
    end;
  end;
end;

function TPartida.ReiEstaEmXeque(aCor: TCor): Boolean;
var
  peca: IPeca;
begin
  Result := False;

  peca := Rei(aCor);
  if peca = nil then
    raise XadrezException.Create('Não existe rei da cor ''' + peca.NomeDaPeca + ''' no tabuleiro!');

  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas[i, j] <> nil then
      begin
        if (FTabuleiro.Pecas[i, j].Cor = Adversario(aCor)) then
        begin
          FTabuleiro.Pecas[i, j].SalvarMovimentosPossiveis;
          if FTabuleiro.Pecas[i, j].MovimentoPossivel(peca.Posicao.Linha, peca.Posicao.Coluna) then
          begin
            Result := True;
            Exit;
            //Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPartida.ValidarPosicaoDeOrigem(aOrigem: IPosicao);
begin
  if FTabuleiro.GetPeca(aOrigem) = nil then
    raise XadrezException.Create('Não existe peça na posição de origem escolhida');

  if FJogadorAtual <> FTabuleiro.GetPeca(aOrigem).Cor then
    raise XadrezException.Create('A peça de origem escolhida não é sua');

  if not FTabuleiro.GetPeca(aOrigem).ExisteMovimentoPossivel then
    raise XadrezException.Create('Não há movimentos possíveis para peça de origem escolhida');
end;

procedure TPartida.ValidarPosicaoDeDestino(aOrigem, aDestino: IPosicao);
begin
  if not FTabuleiro.GetPeca(aOrigem).PodeMoverPara(aDestino) then
    raise XadrezException.Create('Posição de destino inválida');
end;

function TPartida.CorDoJogadorAtual: string;
begin
  Result := EmptyStr;
  if FJogadorAtual = Branca then
    Result := 'Branca'
  else if FJogadorAtual = Preta then
    Result := 'Preta';
end;

procedure TPartida.RetirarTodasPecasDoTabuleiro;
begin
  for var i: integer := 0 to FTabuleiro.Linhas - 1 do
  begin
    for var j: integer := 0 to FTabuleiro.Colunas - 1 do
    begin
      if FTabuleiro.Pecas <> nil then
      begin
        if Assigned(FTabuleiro.Pecas[i, j]) then
          FTabuleiro.Pecas[i, j] := nil;
      end;
    end;
  end;

  for var i: integer := 0 to 15 do
  begin
    if FBrancasCapturadas <> nil then
    begin
      if Assigned(FBrancasCapturadas[i]) then
        FBrancasCapturadas[i] := nil;
    end;
  end;

  for var i: integer := 0 to 15 do
  begin
    if FPretasCapturadas <> nil then
    begin
      if Assigned(FPretasCapturadas[i]) then
        FPretasCapturadas[i] := nil;
    end;
  end;
end;

procedure TPartida.Reiniciar;
begin
  FTabuleiro           := TTabuleiroSingleton.GetInstance(8, 8);
  Turno                := 1;
  FJogadorAtual        := Branca;
  FTerminada           := False;
  FXeque               := False;
  FVulneravelEnpassant := nil;
  SetLength(FBrancasCapturadas, 16);
  SetLength(FPretasCapturadas, 16);
  RetirarTodasPecasDoTabuleiro;
  ColocarPecasNoTabuleiro;
end;

end.
