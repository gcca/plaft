exports.i = new Object

exports.i.captions =
  * 'I-1'
    'El cliente, para efectos de su identificación, presenta información
     \ inconsistenteo de dificilverificaciónpor parte del sujeto obligado.'
    'DJ Datos no coincide con RENIEC o SUNAT.'

  * 'I-2'
    'El cliente declara o registra la misma dirección que la de otras
     \ personas con las que no tiene relación o vínculo aparente.'
    'DJ direccion errada, DA indica otra direccion.'

  * 'I-3'
    'Existencia de indicios de que el ordenante (propietario/titulardel
     \ bien o derecho) ó el beneficiario (adquirente o receptor del bien
     \ o derecho) no actúa por su cuenta y que intentaocultar la identidad
     \ del ordenante o beneficiarioreal.'
    'DJ sin dato tercero, DA indica un tercero como beneficiario.'

  * 'I-4'
    'El cliente presenta una inusual despreocupación por los riesgos
     \ que asume o los importes involucrados en el despacho aduanero
     \ de mercanciaso los costosque implicala operación.'
    'COC DA con riesgos, FC con SN no son precisas, no acepta aforo anticipado,
     \ costos desaduanaje altos.'

  * 'I-5'
    'El cliente realiza operaciones de forma sucesiva y/o reiterada.'
    'COC PN/PJ con operaciones sucesivas sin ser clientes habituales.'

  * 'I-6'
    'El cliente realiza constantementeoperaciones y de modo inusual usa
     \ o pretende utilizardinero en efectivocomo único medio de pago.'
    'DJ dice dinero en efectivo, DA es pagados en efectivo y constantes
     \ operaciones inusuales.'

  * 'I-7'
    'El cliente se rehusa a llenar los formularios o proporcionar
     \ la informaciónrequerida por el sujeto obligado, o se niega a realizar
     \ la operación tan pronto se le solicita.'
    'DA sin DJ se rehusa llenar el formulario Anexo 5.'

  * 'I-8'
    'Las operaciones realizadas por el clienteno corresponden
     \ a su actividad económica.'
    'DJ indica actividad economica que no corresponde actividad economica
     \ de la SUNAT (PN/PJ).'

  * 'I-9'
    'El cliente está siendo investigado o procesado por el delito de lavado
     \ de activos, delitosprecedentes, el delito de financiamiento del
     \ terrorismo y sus delitosconexos, y se toma conocimientode ello
     \ por los medios de difusiónpública u otros medios.'
    'COC cliente investigado LA/FT, conocimiento por difusion periodistica,
     \ radio, TV u otros.'

  * 'I-10'
    'Clientes entre los cuales no hay ninguna relación de parentesco,
     \ financiera o comercial, sean personas naturales o jurídicas;
     \ sin embargo, son representados por una misma persona. Se debe prestar
     \ especial atención cuando dichos clientes tengan fijado sus domicilios
     \ en el extranjero o en paraísos fiscales.'
    'DJ PN/PJ indica domicilios en el extranjero o en paraisos fiscales,
     \ Representados por una misma persona.'

  * 'I-11'
    'El cliente realiza frecuentementeoperaciones por sumas de dinero
     \ que no guardan relación con la ocupación que declara tener.'
    'DJ PN DA por sumas dinero que no guardan relacion con la ocupacion
     \ del cliente.'

  * 'I-12'
    'Solicitud del cliente de realizar despachos aduaneros de mercancias
     \ en condiciones o valores que no guardan relación con las actividades
     \ del dueño o consignatario,o en las condicioneshabitualesdel mercado.'
    'COC DA no guardan relacion con las actividades del dueño.'

  * 'I-13'
    'Solicitud del clientede dividir los pagos por la prestación
     \ del servicio, generalmente,en efectivo.'
    'DJ indica efectivo y el cliente solicita dividir los pagos DA.'

  * 'I-14'
    'Personas naturales o jurídicas, incluyendo sus accionistas, socios,
     \ asociados, socios fundadores, gerentes y directores, que figuren
     \ en alguna listainternacionalde las Naciones Unidas, OFAC o similar.'
    'DJ analizar PN/PJ accionistas, gerentes y directores figuran en alguna
     \ Lista Internacional Naciones Unidas, OFAC o similar.'

  * 'I-15'
    'El cliente presenta una inusual despreocupación por la presentación
     \ o estado de su mercancía o carga y/o de las comisiones y costos
     \ que implicala operación.'
    'COC analizar preocupacion inusual estado mercancia o carga, comisiones
     \ y costos operacion.'

  * 'I-16'
    'El cliente solicita ser excluido del registro de operaciones.'
    'COC cuando detecta que Cliente solicita ser excluido del RO.'

  * 'I-17'
    'El cliente asume el pago de comisiones, impuestos y cualquier
     \ otro costo o tributo generado no sólo por la realización
     \ de sus operaciones, sino la de terceros o a las de otras operaciones
     \ aparentemente no relacionadas.'
    'COC detecta que el cliente asume pago DA de su operacion,
     \ sino la de terceros o otras operaciones.'

  * 'I-18'
    'El cliente realiza frecuentes o significativas operaciones
     \ y declara no realizar o no haber realizado actividad económicaalguna.'
    'COC detecta niega fecuencias de operaciones y declara no haberlo
     \ realizado.'




exports.iii = new Object

Type3 =
  kImport  : 1
  kExport  : 2
  kDeposit : 4
  kAll     : 7

exports.iii.Type = Type3

exports.iii.captions =
  * 'III-1'
    'Existencia de indicios de exportaciones o importación ficticia de bienes
     \ y/o uso de documentos presuntamente falsos o inconsistentes con los
     \ cuales se pretenda acreditar estas operaciones de comercio exterior.'
    'El sectorista o persona que analiza DA.'
    Type3.kImport .|. Type3.kExport

  * 'III-2'
    'Existencia de indicios respecto a que la cantidad de mercancía importada
     \ es superior a la declarada.'
    'DAM numerada o por numerar, el DA tiene aforo rojo despachador
     \ y el vista lo detecta.'
    Type3.kImport

  * 'III-3'
    'Existencia de indicios referidos a que la cantidad de mercancía exportada
     \ es inferior a la declarada.'
    'Despachador lo detecta con aforo antes del embarque.'
    Type3.kExport

  * 'III-4'
    'Cancelaciones reiteradas de órdenes de embarque.'
    'Despachador detecta que Exp no salio embarcada.'
    Type3.kExport

  * 'III-5'
    'Importaciones / exportaciones de gran volumen y/o valor, realizadas
     \ por personas no residentes en el Perú, que no tengan relación
     \ con su actividad económica.'
    'Verificar la actividad economica personas no residentes en el Perú.'
    Type3.kImport .|. Type3.kExport

  * 'III-6'
    'Existencia de indicios de sobrevaloración y/o subvaluación de mercancías
     \ importadas y/o exportadas.'
    'Metodo de valoracion observada por el vista.'
    Type3.kImport .|. Type3.kExport

  * 'III-7'
    'Abandono de mercancías importadas.'
    'Mercancia con fecha llegada mayor 30 dias, DAM no canceladas,
     \ DAM con aforo rojo con observaciones del vista.'
    Type3.kImport

  * 'III-8'
    'Importación de bienes suntuarios (entre otros, obras de arte,
     \ piedras preciosas, antigüedades, vehículos lujosos) que no guardan
     \ relación con el giro o actividad del cliente.'
    'Verificar el giro o actividad del cliente con el DA.'
    Type3.kImport

  * 'III-9'
    'Importaciones / exportaciones desde o hacia paraísos fiscales, o países
     \ considerados no cooperantes por el GAFI o sujetos a sanciones OFAC.'
    'Recurrir regimen reforzado consultar con lista negativas: GAFI, OFAC.'
    Type3.kImport .|. Type3.kExport

  * 'III-10'
    'Importaciones y/o exportaciones realizadas por extranjeros, sin actividad
     \ permanente en el país.'
    'Analizar PN extranjeras o PJ con accionistas exranjeros.'
    Type3.kImport .|. Type3.kExport

  * 'III-11'
    'Importaciones y/o exportaciones realizadas por personas naturales
     \ o jurídicas sin trayectoria en la actividad comercial del producto
     \ importado y/o exportado.'
    'Analizar PN/PJ que se inician en comercio exterior.'
    Type3.kImport .|. Type3.kExport

  * 'III-12'
    'Importaciones y/o exportaciones realizadas por personas jurídicas
     \ que tienen socios jovenes sin experiencia aparente en el sector.'
    'COC para detectar PJ con socios jovenes.'
    Type3.kImport .|. Type3.kExport

  * 'III-13'
    'Importación o almacenamiento de sustancias que se presuma puedan ser
     \ utilizadas para la producción y/o fabricación de estupefacientes.'
    'Verificar con lista subaprtida del D. LEG N° 1126 Control IQPF.'
    Type3.kImport .|. Type3.kDeposit

  * 'III-14'
    'Mercancías que ingresan documentalmente al país, pero no físicamente
     \ sin causa aparente o razonable.'
    'Mercancia no ubicada con volante despacho, no llego en la nave,
     \ no puede emitir DAM.'
    Type3.kImport

  * 'III-15'
    'Despachos realizados para una persona jurídica que tiene la misma
     \ dirección de otras personas jurídicas, las que están vinculadas
     \ por contar con el mismo representante, sin ningún motivo legal
     \ o comercial ó económico aparente.'
    'PJ vinculadas por tener el mismo Representante Legal.'
    Type3.kAll

  * 'III-16'
    'Bienes dejados en depósito que totalizan sumas importantes y que no
     \ corresponden al perfil de la actividad del cliente.'
    'DAM con tipo operacion Deposito, verificar la actividad del cliente
     \ verificar con la SUNAT.'
    Type3.kDeposit

  * 'III-17'
    'Existen indicios de que el valor de los bienes dejados en depósito
     \ no corresponde al valor razonable del mercado.'
    'Aforo de la mercancia observada por el vista por valoracion.'
    Type3.kDeposit

  * 'III-18'
    'Clientes cuyas mercancías presentan constantes abandonos legales
     \ o diferencias en el valor y/o cantidad de la mercancía,
     \ en las extracciones de muestras o en otros controles exigidos
     \ por la regulación vigente.'
    'Cliente con SA constante III 07, III 17, extraccion muestras.'
    Type3.kImport

  * 'III-19'
    'Importaciones y/o exportaciones realizadas de/a principales países
     \ consumidores de cocaína.'
    'Disponer de principales paises consumidores cocaina para verificar pais
     \ de origen y pais destino.'
    Type3.kImport .|. Type3.kExport

  * 'III-20'
    'El instrumento o la orden de pago, giro o remesa que cancele
     \ la importación figure a favor una persona natural o jurídica, distinta
     \ al proveedor del exterior, sin que exista una justificación aparente,
     \ en caso el oficial de cumplimiento cuente con esta información.'
    'OC para cumplir con esta señal debe solicitar al cliente el documento
     \ de pago a su proveedor para su verificacion.'
    Type3.kImport

  * 'III-21'
    'El pago de la importación se ha destinado a un país diferente al país
     \ de origen de la mercancía, sin una justificación aparente.'
    'DAM indica pais de origen, el OC debe tener el documento financiero
     \ o envio de remesa para detectar esta señal.'
    Type3.kImport

  * 'III-22'
    'Existen indicios referidos a que se habrian presentado documentos falsos
     \ o inconsistentes, con los cuales se pretenda acreditar una operación
     \ y/o exportación.'
    'OC detecta SA III 01.'
    Type3.kImport .|. Type3.kExport

  * 'III-23'
    'El pago de la exportación provenga de persona diferente
     \ al comprador/cliente en el exterior o que figure como tal la persona
     \ natural o jurídica que realizó la exportación, sin que exista una
     \ justificación aparente, en caso el oficial de cumplimiento cuente
     \ con esta información.'
    'OC para cumplir con esta señal alerta debe pedir el documento de pago
     \ al exportador.'
    Type3.kExport

  * 'III-24'
    'Personas naturales o jurídicas que hayan realizado exportación de bienes,
     \ sin embargo no solicitan la restitución de derechos
     \ arancelarios - drawback, aun cuando cumplen los requisitos exigidos
     \ por la normativa vigente para acogerse a este beneficio.'
    'Clientes PN/PJ previo analisis de sus DA se detecta el NO acogimiento
     \ al Drawback.'
    Type3.kExport

  * 'III-25'
    'Solicitud de restitución de derechos arancelarios - drawback,
     \ por exportaciones de productos cuyos valores, aparentemente y
     \ de acuerdo a algunos indicios, se encontrarían por encima del precio
     \ del mercado.'
    'Solo se puede detectar con un metodo de valoracion para determinar
     \ precios encima del mercado.'
    Type3.kExport

  * 'III-26'
    'Envíos habituales de pequeños paquetes de mercancías a nombre de una
     \ misma persona o diferentes personas con el mismo domicilio.'
    'Revisar exportaciones con el mismo domicilio.'
    Type3.kExport

  * 'III-27'
    'Transferencia de certificados de depósito entre personas naturales
     \ o jurídicas cuya actividad no guarde relación con los bienes
     \ representados en dichos instrumentos.'
    'Endose de certificados depositos a PN/PJ.'
    Type3.kImport .|. Type3.kDeposit

  * 'III-28'
    'Solicitud de empleo de almacenes de campo sin justificación aparente,
     \ dado el tipo de bien sobre el que se pretende realizar el depósito.'
    'El tipo bien no justifica ingreso deposito aduanero.'
    Type3.kAll

  * 'III-29'
    'El documento de transporte viene a nombre de una persona natural
     \ o jurídica reconocida y luego es endosado a un tercero sin actividad
     \ economica o sin trayectoria en el sector.'
    'Endose documentos (Guia Aerea, Conocimiento Embarque, etc.) PN/PJ
     \ endosa a un tercero.'
    Type3.kAll

  * 'III-30'
    'El importador dificulta o impide el reconocimiento físico
     \ de la mercancia.'
    'DAM numerada con aforo rojo , el cliente impide el reconocimiento fisico.'
    Type3.kImport

  * 'III-31'
    'El cliente realiza operaciones de comercio exterior que no guardan
     \ relación con el giro del negocio.'
    'Analizar el giro del negocio con la SUNAT con cliente nuevos.'
    Type3.kAll

  * 'III-32'
    'Existencia de pagos declarados como anticipos de futuras importaciones
     \ o exportaciones por sumas elevadas, en relacion a las operaciones
     \ habituales realizadas por el cliente, sin embargo existen indicios
     \ de que posteriormente no se realizó la respectiva importacion
     \ o exportacion.'
    'Anticipos pagos por Imp o Exp, y no se realiza estas operaciones,
     \ OC solicita documentacion.'
    Type3.kImport .|. Type3.kExport

  * 'III-33'
    'Importadores o exportadores de bienes inusuales o nuevos que de manera
     \ súbita o esporádica efectuen operaciones que no guarden relacion
     \ por su magnitud con la clase del negocio o con su nueva actividad
     \ comercial, o no tengan la infraestructura suficiente para ello.'
    'Analizar y verificar datos a clientes nuevos.'
    Type3.kImport .|. Type3.kExport
