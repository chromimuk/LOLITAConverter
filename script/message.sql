CREATE OR REPLACE PROCEDURE pa_add_message
(
	vnummessage in number,
	vnumsujet in number,
	vnummembre in number,
	vtexmessage in clob,
	vdtemessage in date,
	vnsumessage in number
)
IS
BEGIN
INSERT INTO message VALUES
(
	vnummessage,
	vnumsujet,
	vnummembre,
	vtexmessage,
	vdtemessage,
	vnsumessage
);
COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE ui_execadd_message
(
	vnummessage in number,
	vnumsujet in number,
	vnummembre in number,
	vtexmessage in clob,
	vdtemessage in date,
	vnsumessage in number
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_message(vnummessage,vnumsujet,vnummembre,vtexmessage,vdtemessage,vnsumessage);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table message');
	htp.print('<a class="btn btn-primary" href="afft_message" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
WHEN OTHERS THEN
	htp.print('ERROR: ' || SQLCODE);
END;
/

CREATE OR REPLACE PROCEDURE ui_frmadd_message
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Creer message');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_message', 'POST');
	htp.print('<table class="table">');
		htp.tableRowOpen;
		htp.tableData('Numero message');
		htp.tableData(htf.formText('vnummessage', 10));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero sujet');
		htp.tableData(htf.formText('vnumsujet', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero membre');
		htp.tableData(htf.formText('vnummembre', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Message');
		htp.tableData(htf.formText('vtexmessage', 1000));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Date');
		htp.tableData(htf.formText('vdtemessage', 10));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero du message dans le sujet');
		htp.tableData(htf.formText('vnsumessage', 4));
		htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/

CREATE OR REPLACE PROCEDURE ui_frmadd_message_sujet
(vnumsujet number default 0) IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Creer message');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_message', 'POST');
	htp.print('<table class="table">');
		htp.tableRowOpen;
		htp.tableData('Numero message');
		htp.tableData(htf.formText('vnummessage', 10));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero sujet');
		htp.tableData(htf.formText('vnumsujet', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero membre');
		htp.tableData(htf.formText('vnummembre', 5));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Message');
		htp.tableData(htf.formText('vtexmessage', 1000));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Date');
		htp.tableData(htf.formText('vdtemessage', 10));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableData('Numero du message dans le sujet');
		htp.tableData(htf.formText('vnsumessage', 4));
		htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/



CREATE OR REPLACE PROCEDURE afft_message
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst IS
	SELECT 
		MS.NUMMESSAGE, S.TITSUJET, ME.NOMMEMBRE, MS.TEXMESSAGE, MS.DTEMESSAGE, MS.NSUMESSAGE
	FROM 
		SUJET S
		Inner Join MESSAGE MS
		On MS.NUMSUJET = S.NUMSUJET
		Inner Join MEMBRE ME
		On ME.NUMMEMBRE = MS.NUMMEMBRE
	ORDER BY
		MS.NUMMESSAGE
	;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table message');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste message');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableHeader('Dans le sujet');
	htp.tableHeader('Ecrit par');
	htp.tableHeader('Message');
	htp.tableHeader('Date');
	htp.tableHeader('N° dans sujet');
	htp.tableRowClose;
	FOR rec IN lst loop
		htp.tableRowOpen;
		htp.tableData(rec.titsujet);
		htp.tableData(rec.nommembre);
		htp.tableData(rec.texmessage);
		htp.tableData(rec.dtemessage);
		htp.tableData(rec.nsumessage);
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/
