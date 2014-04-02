# encoding: utf-8

from uuid import uuid1 as uuid
from interface import BaseHandler
from infraestructure.utils import login_required
from domain import model


BAD_BROWSER_TEMPLATE = (
    '<html>'
    '<head>'
    '<style>'
      'ul {'
        'color: #555;'
        'line-height: 22.4px;'
        'list-style-type: none;'
        'margin-bottom: 0px;'
        'margin-left: 0px;'
        'margin-right: 0px;'
        'margin-top: 0px;'
        'padding-bottom: 0px;'
        'padding-left: 15%;'
        'padding-right: 0px;'
        'padding-top: 0px;'
        'text-align: center;'
      '}'
      'li {'
        'border-bottom-left-radius: 13px;'
        'border-bottom-right-radius: 13px;'
        'border-top-left-radius: 13px;'
        'border-top-right-radius: 13px;'
        'color: #555;'
        'display: block;'
        'float: left;'
        'font-family: Ubuntu,Arial,sans-serif;'
        'line-height: 28.8px;'
        'list-style-type: none;'
        'margin-bottom: 8px;'
        'margin-left: 0px;'
        'margin-right: 29px;'
        'margin-top: 0px;'
        'overflow: hidden;'
        'overflow-x: hidden;'
        'overflow-y: hidden;'
        'text-align: center;'
      '}'
    '</style>'
    '</head>'
    '<body>'
      '<div>'
        '<p>'
          'Su navegador es incompatible con la aplicación. Navegar por internet es más cómodo con uno de lo navegadores recomendados.'
        '</p>'
      '</div>'
      '<ul>'
        '<li style="border-radius: 13px;">'
          '<a target="_blank" href="http://www.mozilla.com/firefox"><img src="/static/img/b-firefox.gif" style="border-radius: 13px; display: block;">Mozilla Firefox</a>'
        '</li>'

        '<li style="border-radius: 13px;">'
          '<a target="_blank" href="http://www.google.com/chrome"><img src="/static/img/b-chrome.gif" style="border-radius: 13px; display: block;">Google Chrome</a>'
        '</li>'

        '<li style="border-radius: 13px;">'
          '<a target="_blank" href="http://www.opera.com/developer/next"><img src="/static/img/b-opera.gif" style="border-radius: 13px; display: block;">Opera</a>'
        '</li>'

        '<li style="border-radius: 13px;">'
          '<a target="_blank" href="http://www.apple.com/safari/download"><img src="/static/img/b-safari.gif" style="border-radius: 13px; display: block;">Safari</a>'
        '</li>'
      '</ul>'
    '</body>'
    '</html>')


def template(name, args=''):
    return ('<html>'
              '<head>'
                '<link rel="stylesheet" href="/static/%(name)s.css">'
                '<meta name="viewport" content="width=device-width,'
                  ' initial-scale=1.0, maximum-scale=1.0, user-scalable=no">'
                  '<meta name="description"'
                    ' content="prevencion de lavado de activos'
                              ' y financiamiento del terrorismo">'
                  '<meta name="author"'
                    'content="Cristhian Alberto Gonzales Castillo">'
                  '<meta charset="UTF-8">'
                  '<title>PLAFT-sw</title>'
              '</head>'
              '<body>'
                '<script>window.plaft={%(args)s}</script>'
                '<script src="/static/%(name)s.js"></script>'
              '</body>'
            '</html>') % {'name': name, 'args': args}


class SignIn(BaseHandler):

    def get(self):
        agent = self.request.headers['User-Agent']
        if ( # No IE!!!
                   -1 != agent.find('Firefox')
                or -1 != agent.find('Chrome')
                or -1 != agent.find('Safari')):
            self.write(template('signin'))
        else:
            self.write(BAD_BROWSER_TEMPLATE)

    def post(self):

        email    = self.request.get('email')
        password = self.request.get('password')

        user = model.User.authenticate(email, password)

        if user:
            self.login(user)
            # self.redirect('/dashboard' + str(uuid())[:8], permanent=True)
            Dashboard.goto(self)
        else:
            self.write(template('signin', 'e:-1'))


class SignOut(BaseHandler):

    def get(self):
        self.logout()
        self.redirect('/')


class Dashboard(BaseHandler):

    @staticmethod
    def goto(self):
        d = model.Datastore()
        args = 'a1: %s' % model.User.find().json
        self.write(template('dashboard', args))

    @login_required
    def get(self):
        self.goto(self)

    @login_required
    def post(self):
        self.goto(self)


class Customer(BaseHandler):

    def get(self):
        self.write(template('customer'))


from datetime import timedelta
from reportlab.lib.enums import TA_JUSTIFY
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, \
                               Table, TableStyle

month_tr = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Setiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre'
}
class DeclarationPDF(BaseHandler):

    def shareholdersList(self, shareholders):
        list = []
        for s in shareholders:
            list.append(['    Nombre', s.name])
            list.append(['    Documento', s.document.type])
            list.append(['    Número', s.document.number])
            list.append(['', ''])
        return list

    def addressList(self, caption, address):
        if address:
            chunkLength = 52
            return ([[caption], ['    ' + address[:chunkLength]]]
                    + [['    ' + address[i:i+chunkLength]]
                       for i in range(chunkLength, len(address), chunkLength)])
        else:
            return [[caption], ['    -']]

    def get(self, id):
        try:
            declaration = model.Declaration.by(int(id))
            if not declaration:
                self.status = self.rc.NOT_FOUND
                return self.write('Not Found')
        except ValueError as e:
            self.status = self.rc.BAD_REQUEST
            return self.write('Bad Request %s' % e)

        customer = declaration.customer

        self.response.headers['Content-Type'] = 'application/pdf'
        doc = SimpleDocTemplate(self.response.out,
                                pagesize=letter,
                                rightMargin=72,
                                leftMargin=72,
                                topMargin=72,
                                bottomMargin=18)

        styles=getSampleStyleSheet()
        styles.add(ParagraphStyle(name='Justify', alignment=TA_JUSTIFY))

        story=[]


        story.append(
            Paragraph('&nbsp;' * 70 + '<font size=12><b>ANEXO N&ordm;5</b></font>',
                      styles['Normal']))
        story.append(Spacer(1, 12))
        story.append(
            Paragraph('&nbsp;' * 33 + '<font size=12><b>Declaración Jurada de Conocimiento del Cliente</b></font>',
                      styles['Normal']))
        story.append(Spacer(1, -10))


        # story.append(Paragraph('<para align=right><b>N&ordm; ' + declaration.tracking + '</b></para>', styles["Normal"]))
        story.append(Paragraph('&nbsp;' * 140 + '<font><b>N&ordm; ' + declaration.tracking + '</b></font>', styles["Normal"]))
        story.append(Spacer(1, 24))

        ptext = '<font size=10>%s</font>' % 'Por el presente documento, declaro bajo juramento, lo siguiente:'
        story.append(Paragraph(ptext, styles["Normal"]))
        story.append(Spacer(1, 10))

        # (-o-) Refactor: use default value
        data = ([
            ['a) Nombres y apellidos:'],
            ['    ' + customer.name],

            ['\nb) Tipo y número del documento de identidad:'],
            ['    ' + customer.document.type
             + '    ' + customer.document.number],

            ['\nc) Registro Único de Contribuyente (RUC):'],
            [('    ' + customer.business) if customer.business else '    -'],

            ['\nd) Fecha y lugar de nacimiento:'],
            [('    ' + customer.birthday) if customer.birthday else '    -'],

            ['\ne) Nacionalidad:'],
            [('    ' + customer.nationality) if customer.nationality else '    -']]

            + self.addressList(
                '\nf) Domilicio declarado (lugar de residencia):',
                customer.address)
                + self.addressList('\ng) Domicilio fiscal:', customer.fiscal)
            + [

            ['\nh) Número de teléfono (fijo y celular):'],
            ['    Fijo: ' + (customer.phone if customer.phone else '    -')],
            ['    Celular: ' + (customer.mobile if customer.mobile else '    -')],

            ['\ni) Correo electrónico:'],
                [('    ' + customer.email) if customer.email else '    -'],

            ['\nj) Profesión u ocupación:'],
                [('    ' + customer.activity) if customer.email else '    -'],


            ['\nk) Estado civil:'],
                [('    ' + customer.status) if customer.status else '    -'],

            ['    1. Nombre del cónyuge:'],
                [('        ' + customer.marital) if customer.marital else '        -'],
            ['    2. Conviviente:'],
                [('        ' + customer.domestic) if customer.domestic else '        -'],

            ['\nl) Cargo o función pública que desempeña o que haya desempeñado en los últimos dos\n   (2) años,  en el Perú o en el extranjero,  indicando  el  nombre  del  organismo público\n   u organización internacional:'],
                [('    ' + customer.public) if customer.public else '    -'],

            ['\nm) El origen de los fondos, bienes u otros activos involucrados en dicha transacción:'],
                [('    ' + declaration.source) if declaration.source else '    -'],

            ['\nn)   ¿Es sujeto obligado informar a la UIF-Perú?'],
                ['         -' if customer.isobliged is None else ('    ' + customer.isobliged)],

            ['\n      ¿Tiene oficial de cumplimiento?'],
                ['         -' if customer.hasofficer is None else ('    ' + customer.hasofficer)],

            ['\no) Identificación del tercero, sea persona natural (nombres y apellidos) o persona jurídica\n    (razón o denominación social) por cuyo intermedio se realiza la operación:',  ''] ,
                [('    ' + declaration.third) if declaration.third else '    -']]) \
        if customer.document.type == 'DNI' else ([
            ['a) Denominación o razón social:'],
                ['    ' + customer.name],

            ['\nb) Registro Único de Contribuyente (RUC):'],
                ['    ' + customer.document.number],

            ['\nc) Objeto social y actividad económica principal (comercial, industrial, construcción,\n    transporte, etc.):'],
                ['    Objeto social: ' + customer.social if customer.social else '    -'],

                [u'    Actividad económica: ' + customer.activity if customer.activity else '    -'],

            ['\nd) Identificación de los accionistas, socios, asociados, que tengan un porcentaje igual\n   o mayor al 5% de las acciones o participaciones de la persona jurídica:', '']]

            + self.shareholdersList(customer.shareholders) + [

            ['e) Identificación del representate legal o de quien comparece con facultades\n    de representación y/o disposición de la persona jurídica:'],
                ['    ' + customer.legal]]

            + self.addressList('\nf) Domilicio:', customer.address)

            + self.addressList('\ng) Domicilio fiscal:', customer.fiscal)

            + [
            ['\nh) Teléfonos fijos de la oficina  y/o  de  la  persona de contacto  incluyendo el código\n    de la ciudad, sea que se trate del local principal, agencia, sucursal u otros locales\n    donde desarrollan las actividades propias al giro de su negocio:'],
                [u'        Teléfono: ' + customer.phone],
                [u'        Contacto: ' + customer.contact],

            ['\ni) El origen de los fondos, bienes y otros activos involucrados en dicha transacción:'],
                ['    ' + declaration.source],

            ['\nj) ¿Es sujeto obligado informar a la UIF-Perú?'],
                ['        ' + ('-' if customer.isobliged is None else customer.isobliged)],

            ['    ¿Tiene oficial de cumplimiento?'],
                ['        ' + ('-' if customer.hasofficer is None else customer.hasofficer)]
            ]

            + ([
                ['\nk) Identificación del tercero, sea persona natural (nombres y apellidos) o persona jurídica\n    (razón o denominación social) por cuyo intermedio se realiza la operación:', ''],
                ['    ' + (declaration.third if declaration.third else '-')]
            ]))

        table = Table(data, [2.2*inch, 3*inch]) #, 10*[.35*inch])
        story.append(table)
        story.append(Spacer(1, 24))

        ptext = '<font size=10>Afirmo y ratifico todo lo manifestado en la presente declaración jurada, en señal de lo cual la firmo, en la fecha que se indica:</font>'
        story.append(Paragraph(ptext, styles["Justify"]))
        story.append(Spacer(1, 64))
        #story.append(Spacer(1, 96))

        ztime = declaration.created.utcnow() - timedelta(hours=5)
        bgdate = ztime.strftime('%d de '
                                + month_tr[ztime.month] + ' del %Y')
        bgtime = ztime.strftime('%H:%M')

        data = [['____________________' , 'Fecha :    ' + bgdate],
                ['               Firma', 'Hora   :    ' +bgtime]]
        table = Table(data, [3*inch, 2.1*inch], 2*[.2*inch])
        story.append(table)
        doc.build(story)
