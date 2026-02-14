//
// ------------------------------------------------------------------
// - Código fuente de BASpeed Universal Edition v14                 -
// - Versión actual 2026.2.14.797 prebeta                           -
// - Creado por José Ignacio Legido (djnacho de bandaancha.eu)      -
// - Fecha del proyecto: 28/12/2025 - 22:07                         -
// - Fecha versión actual: 14/02/2026 - 19:27                       -
// -                                                                -
// - Creado para la comunidad de usuarios de bandaancha.eu y para   -
// - toda la comunidad de internet en general                       -
// -                                                                -
// - Creado usando Delphi 13 Florence                               -
// - Código fuente de libre disposición para todo el mundo          -
// ------------------------------------------------------------------


unit Principal;

interface

// librerías de Delphi que usa internamente la aplicación para poder funcionar

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListBox, FMX.Edit,
  FMX.ComboEdit, FMX.EditBox, FMX.NumberBox, JaugeCir, System.IOUtils,
  Affichage7Seg, JaugeRect, GraphicDefilant, IdHTTP, IdIOHandler,
  IdIOHandlerStack, IdSSLOpenSSL, IdComponent, IdSSLOpenSSLHeaders,
  FMX.DialogService.Async, FMX.ImgList, System.ImageList;

// Ventana principal de la aplicación

type
  TForm4 = class(TForm)
    ToolBar1: TToolBar;                        // Toolbar que se ve en la parte superior de la aplicación
    Image1: TImage;                            // Imagen de la aplicación que se ve en el Toolbar
    Label1: TLabel;                            // Título superior de la aplicación
    GroupBox1: TGroupBox;                      // Grupo de opciones de la conexión
    Label2: TLabel;                            // Título de la selección del tipo de conexión
    ComboEdit1: TComboEdit;                    // Grupo de opciones de selección del tipo de conexión
    Label3: TLabel;                            // Título de las opciones de velocidad
    Label4: TLabel;                            // Título de la velocidad de descarga
    NumberBox1: TNumberBox;                    // Selección numérica de la velocidad de descarga
    Label5: TLabel;                            // Título de la velocidad de subida
    NumberBox2: TNumberBox;                    // Selección numérica de la velocidad de subida
    Label6: TLabel;                            // Título del tipo de conexión a internet del usuario
    ComboEdit2: TComboEdit;                    // Grupo de opciones de selección del tipo de conexión del usuario
    Button1: TButton;                          // Botón para aceptar los datos de conexión del usuario
    Image2: TImage;                            // Imagen para el OK (o Aceptar)
    Panel1: TPanel;                            // Panel donde se incrustan los componentes de las opciones de conexión del usuario
    Rectangle1: TRectangle;                    // Rectángulo que ocupa todo el espacio del panel y que sirve para darle color de fondo al panel (opciones de conexión)
    Panel2: TPanel;                            // Panel donde se incrustan los componentes del test de velocidad
    Rectangle2: TRectangle;                    // Rectángulo que ocupa todo el espacio del panel y que sirve para darle color de fondo al panel (test de velocidad)
    JaugeCir1: TJaugeCir;                      // Medidor analógico semicircular para la velocidad de la conexión
    Label7: TLabel;                            // Título de megabits/s dentro del indicador analógico de velocidad
    Affichage7Seg1: TAffichage7Seg;            // Medidor digital de la velocidad de la conexión
    ComboEdit3: TComboEdit;                    // Grupo de selección del test de velocidad de descarga
    Button2: TButton;                          // Botón de inicio / cancelación del test de velocidad
    JaugeRect1: TJaugeRect;                    // Medidor analógico del porcentage de utilización de la conexíón durante el test de descarga
    Timer1: TTimer;                            // Temporizador para mostrar los datos del test de velocidad cada 250 milisegundos
    Label8: TLabel;                            // Título mostrado encima del medidor digital de velocidad
    Label9: TLabel;                            // Título mostrado encima del grupo de opciones de selección del test de velocidad de descarga
    Label10: TLabel;                           // Título mostrado encima del medidor analógico del porcentage de utilización de la conexión durante el test de descarga
    ProgressBar1: TProgressBar;                // Barra de progreso que muestra el avance del test de velocidad
    Label11: TLabel;                           // Título mostrado encima de la barra de progreso de avance del test de velocidad
    Glyph1: TGlyph;                            // Imagen que se muestra en el botón de Comenzar / Cancelar el test de velocidad
    ImageList1: TImageList;                    // Lista de imagenes diversas que se utilizan para el botón de Comenzar / Cancelar el test de velocidad y para funciones diversas futuras
    procedure FormCreate(Sender: TObject);     // Rutina que se ejecuta antes de mostrar la ventana principal de la aplicación
    procedure Button1Click(Sender: TObject);   // Rutina que se ejecuta al pulsar el botón de aceptar los parámetros de la conexión del usuario
    procedure Button2Click(Sender: TObject);   // Rutina que se ejecuta al pulsar el botón de Comenzar / Cancelar el test de velocidad
    procedure Timer1Timer(Sender: TObject);    // Rutina del temporizador que se ejecuta cada 250 milisegundos
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDescarga = class(TThread)                                 // Rutina multihilo (multitarea) que realiza el test de descarga
              Download      : TidHTTP;                       // Objeto que permite la conexión a servidores HTTP
              ManagerSSL    : TIdSSLIOHandlerSocketOpenSSL;  // Objeto que maneja las conexiones HTTP y HTTPS
              Enlace        : string;                        // Enlace al archivo de descarga
              Memoria       : TMemoryStream;                 // Objeto que recoge los datos enviados al test de velocidad desde el servidor
              TInicial      : UInt64;                        // Tiempo inicial en el que se inicia el test de velocidad
              TFinal        : UInt64;                        // Tiempo final en el que finaliza el test de velocidad
              TTotal        : UInt64;                        // Tiempo total (duración) del test  de velocidad
              Velocidad     : UInt64;                        // Velocidad medida por el test de velocidad
              TamArchivo    : UInt64;                        // Tamaño del archivo del test de velocidad
              TPCDescargado : UInt64;                        // Tanto por ciento (TPC) descargado del archivo usado en el test de velocidad

              // Rutina que calcula los datos necesarios del test de velocidad una vez iniciado (velocidad, TPC descargado, etc)
              procedure CalculaDatos(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

              // Rutina que ejecuta el test de velocidad en un hilo independiente del programa principal
              protected
              procedure Execute;override;
  end;

const
     TAMBUFFER : Int64= 384*1024;        // Tamaño del buffer de memoria que guarda los datos transmitidos desde el servidor del test de velocidad
     NUMHILOS  : Integer= 6;             // Número de hilos simultáneos que se ejecutan en un test de velocidad

var
  Form4: TForm4;                         // Ventana principal del programa
  Test: array[1..6] of TDescarga;        // Array (matriz) de hilos de ejecución del test de descarga
  MaxTPC: Integer;                       // Máximo tanto por ciento de utilización de la velocidad de la conexión
  conexionmax: Double;                   // Variable que permite determinar el tanto por ciento máximo de utilización de la velocidad de conexión

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}

// Rutina de ejecución de cada hilo del test de descarga del test de velocidad

procedure TDescarga.Execute;

var
   contador: Integer;       // Contador intentos de conexión al archivo del servidor

begin
     Velocidad:=0;          // Se establece la velocidad a 0 al inicio del test
     Download:=TIdHTTP.Create; // Crea el objeto que permite acceder al protocolo HTTP
     // Se establece un agente de usuario (User Agent) estándar para evitar que determinados servidores bloqueen el test con el User Agent estándar que usan los componentes Indy
     Download.Request.UserAgent:='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0';
     Download.OnWork:=CalculaDatos; // Se establece la rutina que se ejecuta cada vez que se llene el buffer de datos
     Memoria:=TMemoryStream.Create; // Crea el buffer de memoria para el hilo de ejecución
     Memoria.SetSize(TAMBUFFER);    // Establece el tamaño de buffer de memoria al valor establecido en TAMBUFFER
     ManagerSSL:=TIdSSLIOHandlerSocketOpenSSL.Create;       // Crea el objeto que permite manejar los protocolos HTTP y HTTPS
     ManagerSSL.SSLOptions.Method:=TIdSSLVersion.sslvTLSv1_2;  // En caso de usar HTTPS se usa el protocolo TLS v1.2 (estándar actual para conexiones HTTPS)
     ManagerSSL.ConnectTimeout:=5000;                          // Tiempo máximo hasta fallo por tiempo de espera hasta conexión con el servidor
     ManagerSSL.ReadTimeout:=5000;                             // Tiempo máximo hasta fallo por tiempo de espera hasta lectura de datos desde el servidor
     ManagerSSL.RecvBufferSize:=TAMBUFFER;                     // Se establece que el tamaño del buffer de lectura es el establecido en la constante TAMBUFFER
     Download.IOHandler:=ManagerSSL;                           // Se establece que el operador de la conexión es el objeto que permite usar los protocolos HTTP y HTTPS
     case Form4.ComboEdit3.ItemIndex of                        // Establece los enlaces a los distintos servidores dependiendo del test de velocidad elegido
          0 : Enlace:='https://testvelocidad.eu/speed-test/download.bin';
          1 : Enlace:='https://es.download.nvidia.com/Windows/581.80/581.80-desktop-win10-win11-64bit-international-dch-whql.exe';
          2 : Enlace:='http://ipv4.download.thinkbroadband.com/1GB.zip';
          3 : Enlace:='https://gra.proof.ovh.net/files/1Gb.dat';
          4 : Enlace:='https://mad.download.datapacket.com/1000mb.bin';
          5 : Enlace:='http://212.183.159.230/1GB.zip';
          6 : Enlace:='https://lon.speedtest.clouvider.net/1g.bin';
     end;
     Download.Head(Enlace);                                        // Descarga la cabecera (información) del enlace seleccionado
     TamArchivo:=Download.Response.ContentLength;                  // Establece que el tamaño del archivo es el valor devuelto por el servidor en ContentLength
     TInicial:=GetTickCount64;                                     // Establece el tiempo inicial en el que se inicia el test de velocidad (número de milisegundos desde que el sistema se inició por última vez)
     contador:=1;                                                  // Establece el contador de intentos de conexión a 1
     try
        Download.Get(Enlace,Memoria);                        // Intenta descarga el archivo
     except
           on Exception do
                          begin
                               ManagerSSL.Close;                              // En caso de fallo cierra la conexión SSL
                               Download.Disconnect;                           // Y desconecta del servidor HTTP/HTTPS
                          end;
     end;
     Memoria.Free;                                                 // Libera la memoria asignada al buffer de memoria del hilo
     ManagerSSL.Free;                                              // Libera la memoria asignada al objeto que maneja las conexiones HTTP y HTTPS
     Download.Free;                                                // Libera la memoria asignada al objeto que permite la conexión a servidores HTTP y HTTPS
     Terminate;                                                    // Termina la ejecución del hilo asignando TRUE a la variable terminated del hilo
end;

// Rutina que realiza los cálculos de datos para el test de velocidad

procedure TDescarga.CalculaDatos(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

begin
     if (Terminated) then
        begin
             ManagerSSL.Close;                     // Si se ha terminado el test cierra la conexión SSL
             Download.Disconnect;                  // Y desconecta del servidor HTTP/HTTPS
        end
     else
         begin
              Memoria.Seek(0,soFromBeginning);     // Vuelve a apuntar el puntero del buffer al principio del buffer de memoria
              TFinal:=GetTickCount64;              // Calcula el tiempo final desde que se inició el test (en milisegundos desde que se inició por última vez el sistema)
              TTotal:=TFinal - TInicial;           // El tiempo total es la resta del tiempo final y tiempo inicial
              Velocidad:=(AWorkCount div TTotal)*8;   // La velocidad media es la división del número total de datos descargados entre el tiempo transcurrido y multiplicado por 8 para que el resultado sea en Kilobit/s
              TPCDescargado:=(AWorkCount*100) div TAMArchivo; // El tanto por ciento descargado del archivo es el número de bytes descargados multiplados por cien y dividido el resultado entre el tamaño total del archivo
         end;
end;

// Rutina que se ejecuta al pulsar el botón de aceptar los datos de conexión del usuario.

procedure TForm4.Button1Click(Sender: TObject);

var
   configuracion: TStringList;        // Los datos de la conexión se guarda en una lista de cadenas de caracteres

begin
     configuracion:=TStringList.Create;  // Crea la lista de cadenas de caracteres
     configuracion.Add(ComboEdit1.ItemIndex.ToString);    // Añade el tipo de conexión
     configuracion.Add(NumberBox1.Value.ToString);        // Añade la velocidad de descarga de la conexión
     configuracion.Add(NumberBox2.Value.ToString);        // Añade la velocidad de subida de la conexión
     configuracion.Add(ComboEdit2.ItemIndex.ToString);    // Añade el operador de la conexión
     configuracion.SaveToFile(TPath.GetDocumentsPath+TPath.DirectorySeparatorChar+'baspeed.cfg');   // Graba el archivo de configuración en el equipo
     configuracion.Free;     // Libera la memoria dedicada los datos de la conexión del usuario
     Panel1.Visible:=False;  // El panel 1 (opciones de la conexión) se oculta
     Panel2.Visible:=True;   // El panel 2 (test de descarga) se hace visible
end;

// Rutina que activa el test de velocidad al dar el botón de comenzar test de velocidad

procedure TForm4.Button2Click(Sender: TObject);

var
   contador: Integer;                 // Contador de hilos de ejecución

begin
     // Primero se comprueba si hay algún test de velocidad activo. Para ello se comprueba si alguna de las variables de la matriz del test
     // de velocidad tiene asignada una zona de memoria (lo cual indica que ese hilo en concreto está activo). Si hay alguno activo se desconecta
     // cualquier transferencia y se termina el hilo de ejecución (se cancela el test de velocidad)

     // Si alguno de los hilos de ejecución aún está activo
     if Assigned(test[1]) or Assigned(test[2]) or Assigned(test[3]) or Assigned(test[4]) or Assigned(test[5]) or Assigned(test[6]) then
        begin
             // Comprueba cada hilo de ejecución
             for contador := 1 to 6 do
                 // Si aún está activo
                 if Assigned(test[contador]) then
                    begin
                         test[contador].Terminate;          // Termina la ejecución del hilo
                    end;
        end
     else
         // En caso de no tener ningún hilo de ejecución activo, se activan todos los hilos de ejecución y se da comienzo al test de velocidad
         begin
              conexionmax:=0;   // Se establece el porcentaje máximo de utilización de la conexión a 0
              Glyph1.ImageIndex:=1;   // El icono que aparece en el botón es el de cancelar el test
              Button2.Text:='Cancelar test de velocidad';     // Se cambia el mensaje del botón a Cancelar test de velocidad
              MaxTPC:=Trunc(NumberBox1.Value);                // El máximo valor para calcular el porcentaje de utilización de conexión es el valor de la velocidad de descarga de la conexión
              Timer1.Enabled:=True;                           // Se activa el temporizador para empezar a mostrar los datos
              // Activa todos los hilos de ejecución
              for contador := 1 to NUMHILOS do
                  begin
                       test[contador]:=TDescarga.Create(True); // Crea el hilo de ejecución en modo de espera
                       test[contador].Start;                   // Inicia el hilo de ejecución (método Execute de TDescarga)
                  end;
         end;
end;

// Rutina que se ejecuta cuando se crea la ventana principal de la aplicación y antes de mostrar la ventana

procedure TForm4.FormCreate(Sender: TObject);

var
   configuracion: TStringList; // Lista de cadena de caracteres que guarda el fichero de configuración de BASpeed

begin
     // Si se está compilando la aplicación para Android
     {$IFDEF ANDROID}
     // Situa la ruta a las librerias OpenSSL en el directorio /data/data/<application ID>/files (Donde se guardan los documentos internos de la aplicación)
     IdOpenSSLSetLibPath(TPath.GetDocumentsPath);
     {$ENDIF}
     // En caso de no compilarse la aplicación para Android, la ruta de acceso es la carpeta donde se encuentre la aplicación
     JaugeCir1.Valeur:=0;        // Indicador analógico de velocidad a 0
     JaugeRect1.Valeur:=0;       // Indicador analógico de porcentaje de utilización de velocidad de conexión a 0
     JaugeRect1.Maxi:=100;       // Valor máximo del indicador de porcentaje de utilización de velocidad de conexión
     JaugeRect1.Mini:=0;         // Valor mínimo del indicador de porcentaje de utilización de velocidad de conexión
     ProgressBar1.Value:=0;      // Barra de progreso del test de velocidad a 0
     // Si existe el fichero de configuración en el fichero Home del usuario
     if FileExists(TPath.GetDocumentsPath+TPath.DirectorySeparatorChar+'baspeed.cfg',false) then
        begin
             configuracion:=TStringList.Create; // Crea la lista de cadena de caracteres
             configuracion.LoadFromFile(TPath.GetDocumentsPath+TPath.DirectorySeparatorChar+'baspeed.cfg'); // Carga el fichero de configuración en la lista de cadenas
             ComboEdit1.ItemIndex:=configuracion[0].ToInteger; // Carga el valor del tipo de conexión
             NumberBox1.Value:=configuracion[1].ToInteger;     // Carga la velocidad de descarga
             NumberBox2.Value:=configuracion[2].ToInteger;     // Carga la velocidad de subida
             ComboEdit2.ItemIndex:=configuracion[3].ToInteger; // Carga el operador de la conexión
             configuracion.Free;                               // Libera la memoria asignada a la lista de cadenas de caracteres
             Panel1.Visible:=False;                            // El panel 1 (configuración de la conexión) se oculta
             Panel2.Visible:=True;                             // El panel 2 (test de velocidad) se hace visible
        end;
end;

// Rutina que se ejecuta cada 250 milisegundos para mostrar al usuario la información del test de velocidad

procedure TForm4.Timer1Timer(Sender: TObject);

var
   vtotal      : UInt64;             // Velocidad total suma de la velocidad alacanzada por todos los hilos de ejecución
   contador    : Integer;            // Contador de hilos de ejecución
   tpcconexion : Double;             // Tanto por ciento de utilización de la conexión

begin
     vtotal:=0;                      // Se asigna la velocidad total a 0
     contador:=1;                    // Contador de hilos de ejecución a 1
     repeat
           vtotal:=vtotal+test[contador].Velocidad; // Se suma la velocidad de cada hilo de ejecución
           Inc(contador,1);                         // Incrementa el número de hilo de ejecución en una unidad
     until (contador>NUMHILOS);                     // Repetir hasta que se llegue al número máximo de hilos
     Affichage7Seg1.Valeur:=Format('%.8d',[vtotal]);   // Se asigna el valor de vtotal al indicador digital de velocidad con un formato de 8 dígitos
     JaugeCir1.Valeur:=vtotal/1000;                    // Se asigna el valor de vtotal/1000 (para mostrar la velocidad en megabit/s) al indicador analógico de velocidad
     tpcconexion:=((vtotal/1000)*100)/MaxTPC;          // Se calcula el tanto por ciento de utilización de la conexión
     if (tpcconexion>conexionmax) then                 // Si el valor del TPC de utilización de la conexión es mayor que el valor máximo anterior
        conexionmax:=tpcconexion;                      // Entonces el valor de TPC de utilización de la conexión pasa a ser ese valor máximo
     // Se calcula el progreso del test de velocidad
     ProgressBar1.Value:=(test[1].TPCDescargado+test[2].TPCDescargado+test[3].TPCDescargado+test[4].TPCDescargado+test[5].TPCDescargado+test[6].TPCDescargado)/6;
     Label11.Text:='Progreso '+Round(ProgressBar1.Value).ToString+'%'; // Se muestra el progreso con un valor númerico porcentual dentro de la barra de progreso
     JaugeRect1.Valeur:=conexionmax; // Se muestra el valor del tanto por ciento de utilización de la conexión
     // Si todos los hilos de ejecución han terminado su tarea
     if (Test[1].Terminated=True) and (Test[2].Terminated=True) and (Test[3].Terminated=True) and (Test[4].Terminated=True) or
        (Test[5].Terminated=True) and (Test[6].Terminated=True) then
        begin
             Timer1.Enabled:=False;   // Se desactiva el temporizador para mostrar datos del test de velocidad
             // Libera y anula todos los hilos de ejecución del test de velocidad
             for contador := 1 to 6 do
                 FreeAndNil(test[contador]);
             JaugeCir1.Valeur:=0;           // Indicador analógico de velocidad a 0
             JaugeRect1.Valeur:=0;          // Indicador analógico de porcentaje de utilización de la conexión a 0
             ProgressBar1.Value:=0;         // Barra de progreso del test de velocidad a 0
             Label11.Text:='Progreso 0%';   // Inicializa de nuevo el texto dentro de la barra de progreso a 0
             Affichage7Seg1.Valeur:='00000000';           // Inicializa el indicador digital de la velocidad de conexión a 0
             Glyph1.ImageIndex:=0;                        // El icono del botón se cambia para indicar que puede realizar otro test de velocidad
             Button2.Text:='Comenzar test de velocidad';  // Inicializa el texto del botón a Comenzar test de velocidad
             // Muestra en pantalla un informe con los datos del test de velocidad, haya este finalizado, o haya sido cancelado por el usuario
             TDialogServiceAsync.MessageDialog('Test finalizado'#10+
                                          'Test utilizado: '+ComboEdit3.Text+#10+
                                          'Velocidad máxima: '+vtotal.ToString+' Kbit/s ('+(vtotal div 1000).ToString+' Mbit/s)'#10+
                                          'Porcentaje máximo utilizado de la conexión: '+Trunc(conexionmax).ToString+'%',TMsgDlgType.mtInformation,
                                          [TMsgDlgBtn.mbOK],TMsgDlgBtn.mbOK,0);
        end;
end;

end.
