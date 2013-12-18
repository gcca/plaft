# -*- coding: utf-8 -*-

from infraestructure.utils import user_required
from interface import BaseHandler
from domain.model import Declaration, Customer

# --------------
# Basic Template
# --------------
def generic(template, args=''):
    return (
        '<html>'
        '<head>'
        '<link rel="stylesheet" href="/static/%(template)s.css">'
        '<meta name="viewport" content="width=device-width, '
        'initial-scale=1.0, maximum-scale=1.0, user-scalable=no">'
        '<title>PLAFT-sw</title>'
        '</head>'
        '<body>'
        '<script>window.params={%(args)s}</script>'
        '<script src="/static/%(template)s.js"></script>'
        '</body>'
        '</html>') % {'template': template, 'args': args}

# ----------------
# Sign In/Out View
# ----------------
class SignInView(BaseHandler):

    def write_signin(self, args=''):
        self.write(generic('signin', args))

    def write_badbrowser(self):
        self.write(
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
            '</html>'
        )

    def get(self):
        agent = self.request.headers['User-Agent']
        self.headers_reval()
        if ( # No IE!!!
                -1 != agent.find('Firefox')
                or -1 != agent.find('Chrome')
                or -1 != agent.find('Safari')):
            self.write_signin()
        else:
            self.write_badbrowser()

class SignOutView(BaseHandler):

    def get(self):
        self.logout()
        self.redirect('/')

# ------------------
# Customer Form View
# ------------------
class CustomerFormView(BaseHandler):

    def get(self):
        self.write(generic('customer-form'))

# -------------
# Customer View
# -------------
class CustomerView(BaseHandler):

    def get(self):
        self.write(generic('customer'))

# --------------
# Dashboard View
# --------------
class DashboardView(BaseHandler):

    @user_required
    def get(self):
        self.headers_reval()
        self.write(generic('dashboard'))

# --------
# Movement
# --------
from datetime import timedelta #, datetime
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

class DeclarationPDFView(BaseHandler):

    def shareholdersList(self, shareholders):
        list = []
        for s in shareholders:
            list.append(['    Nombre', s['name']])
            list.append(['    Documento', s['documentType']])
            list.append(['    Número', s['documentNumber']])
            list.append(['', ''])
        return list

    def addressList(self, caption, address):
        chunkLength = 52
        return ([[caption, address[:chunkLength]]]
                + [['', address[i:i+chunkLength]]
                   for i in range(chunkLength, len(address), chunkLength)])

    def get(self, id):
        try:
            declaration = Declaration.by(int(id))
            if not declaration:
                self.status = self.rc.NOT_FOUND
                return self.write('Not Found')
        except ValueError as e:
            self.status = self.rc.BAD_REQUEST
            return self.write('Bad Request %s' % e)

        customer = declaration.customer.like(Customer)

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

        story.append(Paragraph('<para align=right><b>ID: ' + declaration.trackingId + '</b></para>', styles["Normal"]))
        story.append(Spacer(1, 36))

        ptext = '<font size=10>%s</font>' % 'Por el presente documento, declaro bajo juramento, lo siguiente:'
        story.append(Paragraph(ptext, styles["Normal"]))
        story.append(Spacer(1, 36))

        data = ([
            ['Nombres y Apellidos' , customer.name],
            ['Documento'   , customer.documentType],
            ['Número'     , customer.documentNumber],
            ['RUC' , customer.businessNumber if customer.businessNumber else '-'],
            ['Fecha y lugar de nacimiento' , customer.birthday if customer.birthday else ''],
            ['Nacionalidad'        , customer.nationality]]
            + self.addressList('Domilicio declarado', customer.address)
            + self.addressList('Domicilio fiscal', customer.officialAddress)
            + [['', ''],
            ['Teléfono fijo' , customer.phone],
            ['Celular'    , customer.mobile],
            ['Correo electrónico' , customer.email],
            ['', ''],
            ['Profesión u ocupación' , customer.activity],
            ['Estado civil' , customer.civilStatus],
            ['    Nombre del cónyuge' , customer.maritalPartner],
            ['    Conviviente', customer.domesticPartner if customer.domesticPartner else '-'],
            ['', ''],
            ['Cargo o función pública', customer.publicOffice],
            ['', ''],
            ['Origen de los fondos'  , declaration.source],
            ['', ''],
            ['¿Es sujeto obligado?', 'Sí' if customer.isObliged else 'No'],
            ['¿Tiene oficial de cumplimiento?' , 'Sí' if customer.hasOfficier else 'No'],
        ] + ([['', ''],
            ['Beneficiario'            , ''],
            ['    Nombre'              , declaration.thirdName]])) \
        if customer.className is 'Person' else ([
            ['Razón Social'        , customer.name],
            ['RUC'                 , customer.documentNumber],
            ['', ''],
            ['Objeto social'       , customer.socialObject],
            ['Actividad económica' , customer.activity],
            ['', ''],
            ['Accionistas:', '']]
            + self.shareholdersList(customer.shareholders) + [
            ['Representate legal'  , customer.legal]]
            + self.addressList('Domilicio', customer.address)
            + self.addressList('Domicilio fiscal', customer.officialAddress)
            + [['', ''],
            ['Teléfono'            , customer.phone],
            ['Contacto'            , customer.contact],
            ['', ''],
            ['Origen de los fondos'  , declaration.source],
            ['', ''],
            ['¿Es sujeto obligado?', customer.isObliged],
            ['¿Tiene oficial de cumplimiento?' , customer.hasOfficier]]
            + ([['', ''],
                ['Beneficiario'  , ''],
                ['    Nombre'    ,
                 declaration.thirdName if declaration.thirdName else '-']
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
