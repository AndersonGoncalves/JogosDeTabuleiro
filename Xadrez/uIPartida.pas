unit uIPartida;

interface

uses
  uITabuleiro, uCor;

type
  IArrayOfCapturadas = Array of IPeca;

  IPartida = Interface
  ['{788CC3BE-04A0-465B-85C6-0934E50D6BBD}']
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
    procedure ColocarNovaPeca(aColuna: char; aLinha: Integer; aPeca: IPeca);
    Procedure RealizarJogada(aOrigem, aDestino: IPosicao);
    procedure ValidarPosicaoDeOrigem(aOrigem: IPosicao);
    procedure ValidarPosicaoDeDestino(aOrigem, aDestino: IPosicao);
    function CorDoJogadorAtual: string;
    procedure RetirarTodasPecasDoTabuleiro;
    procedure Reiniciar;
    property Tabuleiro           : ITabuleiro         read GetTabuleiro           write SetTabuleiro;
    property Turno               : Integer            read GetTurno               write SetTurno;
    property JogadorAtual        : TCor               read GetJogadorAtual        write SetJogadorAtual;
    property Terminada           : Boolean            read GetTerminada           write SetTerminada;
    property PretasCapturadas    : IArrayOfCapturadas read GetPretasCapturadas    write SetPretasCapturadas;
    property BrancasCapturadas   : IArrayOfCapturadas read GetBrancasCapturadas   write SetBrancasCapturadas;
    property Xeque               : Boolean            read GetXeque               write SetXeque;
    property VulneravelEnpassant : IPeca              read GetVulneravelEnpassant write SetVulneravelEnpassant;
    property Empate              : Boolean            read GetEmpate;
  end;

implementation

end.
