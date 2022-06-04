unit uITabuleiro;

interface

uses
  uCor;

type
  IPosicao = Interface
  ['{E54780E9-D6A4-42E1-99DE-06F745FD79C5}']
    procedure DefinirValores(aLinha, aColuna: Integer);
    function GetLinha: Integer;
    procedure SetLinha(const Value: Integer);
    function GetColuna: Integer;
    procedure SetColuna(const Value: Integer);
    property Linha : Integer read GetLinha  write SetLinha;
    property Coluna: Integer read GetColuna write SetColuna;
  end;

  ITabuleiro = Interface;
  TArrayOfArrayBoolean = Array of Array of Boolean;

  IPeca = Interface
  ['{9E895284-6C3D-42A5-B744-D7C08461CE8E}']
    function GetTabuleiro: ITabuleiro;
    function GetCor: TCor;
    function GetPosicao: IPosicao;
    procedure SetPosicao(const Value: IPosicao);
    function GetQuantidadeMovimento: Integer;
    procedure SetQuantidadeMovimento(const Value: Integer);
    function GetMovimentosPossiveis: TArrayOfArrayBoolean;
    procedure SetMovimentosPossiveis(const Value: TArrayOfArrayBoolean);
    function GetNomeDaPeca: String;
    procedure SetNomeDaPeca(const Value: String);
    function PodeMover(aPosicao: IPosicao): Boolean;
    procedure IncrementarQuantidadeMovimento;
    procedure DecrementarQuantidadeMovimento;
    function MovimentoPossivel(aLinha, aColuna: Integer): Boolean;
    function ExisteMovimentoPossivel: Boolean;
    function PodeMoverPara(aPosicao: IPosicao): Boolean;
    procedure SalvarMovimentosPossiveis;
    property Tabuleiro           : ITabuleiro           read GetTabuleiro;
    property Cor                 : TCor                 read GetCor;
    property Posicao             : IPosicao             read GetPosicao             write SetPosicao;
    property QuantidadeMovimento : Integer              read GetQuantidadeMovimento write SetQuantidadeMovimento;
    property MovimentosPossiveis : TArrayOfArrayBoolean read GetMovimentosPossiveis write SetMovimentosPossiveis;
    property NomeDaPeca          : String               read GetNomeDaPeca          write SetNomeDaPeca;
  end;

  IArrayOfArrayPecas = Array of Array of IPeca;

  ITabuleiro = Interface
  ['{3AC864F8-72DB-4D6F-A230-213E80CAE6F6}']
    function GetLinhas: Integer;
    procedure SetLinhas(const Value: Integer);
    function GetColunas: Integer;
    procedure SetColunas(const Value: Integer);
    function GetPecas: IArrayOfArrayPecas;
    procedure SetPecas(const Value: IArrayOfArrayPecas);
    function GetPeca(aLinha, aColuna: Integer): IPeca; overload;
    function GetPeca(aPosicao: IPosicao): IPeca; overload;
    function PosicaoValida(aLinha, aColuna: Integer): Boolean;
    function RetirarPeca(aLinha, aColuna: Integer): IPeca;
    procedure ColocarPeca(aPeca: IPeca); overload;
    procedure ColocarPeca(aPeca: IPeca; aPosicao: IPosicao); overload;
    procedure DefinirValores(aLinhas, aColunas: Integer);
    procedure Release;
    property Linhas : Integer            read GetLinhas  write SetLinhas;
    property Colunas: Integer            read GetColunas write SetColunas;
    property Pecas  : IArrayOfArrayPecas read GetPecas   write SetPecas;
  end;

implementation

end.
