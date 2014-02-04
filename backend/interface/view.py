# encoding: utf-8

from interface import BaseHandler
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

        if email and password:
            self.redirect('/dashboard')
        else:
            raise Exception('Bad email or password')

        self.write('')


class SignOut(BaseHandler):

    def get(self):
        self.logout()
        self.redirect('/')


class Dashboard(BaseHandler):

    def get(self):
        args = 'a1: %s' % model.User.find().json
        self.write(template('dashboard', args))


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
            return ([[caption, address[:chunkLength]]]
                    + [['', address[i:i+chunkLength]]
                       for i in range(chunkLength, len(address), chunkLength)])
        else:
            return [[caption, '']]

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

        ptext = '<font size=14><b>DECLARACIÓN JURADA</b></font>'
        story.append(Paragraph(ptext, styles["Normal"]))
        story.append(Spacer(1, -8))

        story.append(Paragraph('<para align=right><b>ID: ' + declaration.tracking + '</b></para>', styles["Normal"]))
        story.append(Spacer(1, 36))

        ptext = '<font size=10>%s</font>' % 'Por el presente documento, declaro bajo juramento, lo siguiente:'
        story.append(Paragraph(ptext, styles["Normal"]))
        story.append(Spacer(1, 36))

        data = ([
            ['Nombres y Apellidos' , customer.name],
            ['Documento'   , customer.document.type],
            ['Número'     , customer.document.number],
            ['RUC' , customer.businessNumber if customer.business else '-'],
            ['Fecha y lugar de nacimiento' , customer.birthday if customer.birthday else ''],
            ['Nacionalidad'        , customer.nationality]]
            + self.addressList('Domilicio declarado', customer.address)
                + self.addressList('Domicilio fiscal', customer.fiscal)
            + [['', ''],
            ['Teléfono fijo' , customer.phone],
            ['Celular'    , customer.mobile],
            ['Correo electrónico' , customer.email],
            ['', ''],
            ['Profesión u ocupación' , customer.activity],
               ['Estado civil' , customer.status],
            ['    Nombre del cónyuge' , customer.marital],
            ['    Conviviente', customer.domesticPartner if customer.domestic else '-'],
            ['', ''],
            ['Cargo o función pública', customer.public],
            ['', ''],
            ['Origen de los fondos'  , declaration.source],
            ['', ''],
            ['¿Es sujeto obligado?', 'Sí' if customer.isobliged else 'No'],
            ['¿Tiene oficial de cumplimiento?' , 'Sí' if customer.hasofficier else 'No'],
        ] + ([['', ''],
            ['Identificación del tercero'   , declaration.third]])) \
        if customer.document.type == 'DNI' else ([
            ['Razón Social'        , customer.name],
            ['RUC'                 , customer.document.number],
            ['', ''],
            ['Objeto social'       , customer.social],
            ['Actividad económica' , customer.activity],
            ['', ''],
            ['Accionistas:', '']]
            + self.shareholdersList(customer.shareholders) + [
            ['Representate legal'  , customer.legal]]
            + self.addressList('Domilicio', customer.address)
            + self.addressList('Domicilio fiscal', customer.fiscal)
            + [['', ''],
            ['Teléfono'            , customer.phone],
            ['Contacto'            , customer.contact],
            ['', ''],
            ['Origen de los fondos'  , declaration.source],
            ['', ''],
            ['¿Es sujeto obligado?', customer.isobliged],
            ['¿Tiene oficial de cumplimiento?' , customer.hasofficier]]
            + ([['', ''],
                ['Identificación del tercero',
                 declaration.thirdName if declaration.third else '-']
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
