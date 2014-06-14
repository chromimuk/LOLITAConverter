CREATE OR REPLACE PROCEDURE pa_add_codelolita
(
vnature in varchar2,
vcode in varchar2,
vlibelle in varchar2
)
IS
BEGIN
INSERT INTO codelolita VALUES
(
vnature,
vcode,
vlibelle
);
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE ui_execadd_codelolita
(
vnature in varchar2,
vcode in varchar2,
vlibelle in varchar2
)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
htp.print('<!DOCTYPE html>');
htp.htmlOpen;
htp.headOpen;
htp.title('Insertion codelolita');
htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
htp.headClose;
htp.bodyOpen;
htp.print('<div class="container">');
pa_add_codelolita(vnature,vcode,vlibelle);
htp.header(1, 'LOLITA');
htp.hr;
htp.header(2, 'Ajout effectue dans la table codelolita');
htp.print('<a class="btn btn-primary" href="afft_codelolita" >Voir la liste complete</a>');
htp.print('</div>');
htp.bodyClose;
htp.htmlClose;
EXCEPTION
WHEN OTHERS THEN
htp.print('ERROR: ' || SQLCODE);
END;
/

CREATE OR REPLACE PROCEDURE ui_frmadd_codelolita
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
htp.print('<!DOCTYPE html>');
htp.htmlOpen;
htp.headOpen;
htp.title('Insertion codelolita');
htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
htp.headClose;
htp.bodyOpen;
htp.print('<div class="container">');
htp.header(1, 'Ajout élément dans la table codelolita');
htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_codelolita', 'POST');
htp.print('<table class="table">');
htp.tableRowOpen;
htp.tableData('vnature');
htp.tableData(htf.formText('vnature', 3));
htp.tableRowClose;
htp.tableRowOpen;
htp.tableData('vcode');
htp.tableData(htf.formText('vcode', 3));
htp.tableRowClose;
htp.tableRowOpen;
htp.tableData('vlibelle');
htp.tableData(htf.formText('vlibelle', 50));
htp.tableRowClose;
htp.tableClose;
htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
htp.formClose;
htp.print('</div>');
htp.bodyClose;
htp.htmlClose;
END;
/

CREATE OR REPLACE PROCEDURE afft_codelolita
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
CURSOR lst IS SELECT * FROM CODELOLITA;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table codelolita');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste codelolita');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Nature');
	htp.tableHeader('Code');
	htp.tableHeader('Libelle');
	htp.tableRowClose;
	FOR rec IN lst loop
		if rec.nature = 'STA' then
			htp.tableRowOpen(cattributes => 'class=info');
		elsif rec.nature = 'DRO' then
			htp.tableRowOpen(cattributes => 'class=success');
		else 
			htp.tableRowOpen;
		end if;
		htp.tableData(rec.nature);
		htp.tableData(rec.code);
		htp.tableData(rec.libelle);
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/
