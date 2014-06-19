CREATE OR REPLACE
PROCEDURE hello
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	user_id number(5);
	user_name varchar2(80);
	user_type varchar2(2);
	user_right varchar2(4);
	user_rights array_t;
BEGIN
	get_info_user(user_id, user_name, user_type);
    	get_info_user_right(user_right);
    	get_info_user_rights(user_rights);
    	
    	
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
		htp.headOpen;
			htp.title('LOLITA');
			htp.print('<link href="https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css" rel="stylesheet">');
		htp.headClose;
		htp.bodyOpen;
			htp.print('<div class="container">');

			header(user_id, user_name, user_type, user_right);

			if (user_id >= 0)
			then 
				htp.hr;
				htp.header(2,'Nos domaines de compétences');
				htp.print('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
				htp.br;
				htp.br;
				htp.print('<a class="btn btn-primary" href="afft_domaine_user" >Consulter nos domaines de compétences</a>');
				htp.hr;
				htp.header(2,'Nos experts');
				htp.print('Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.');
				htp.br;
				htp.br;
				htp.print('<a class="btn btn-primary" href="afft_membre_user" >En savoir plus sur nos experts</a>');
				htp.hr;
				htp.header(2,'Questions/réponses');
				htp.print('<a class="btn btn-primary" href="afft_sujet_from_type_user?vlibtypesujet=FQ" >Consulter la FAQ</a>');
				htp.print('<a class="btn btn-primary" href="afft_sujet_from_type_user?vlibtypesujet=QR" >Consulter la liste des sujets</a>');
				htp.print('<a class="btn btn-primary" href="ui_frmadd_sujet" >Creer un nouveau sujet</a>');
				htp.print('</div>');
					
			else
				htp.br;

				htp.print('<div style="text-align: center">');
				htp.br;
				
				htp.header(1, 'Des questions en informatique ?');
				htp.br;
				htp.header(1, 'Des problématiques difficiles à résoudre ?');
				htp.br;
				htp.br;
				htp.br;
				
				htp.header(2,'LOLITA peut vous aider à trouver des solutions !');
				htp.br;
				htp.br;
				htp.br;
				
				htp.header(2, 'Parlez-en à votre PDG.');
				
				htp.br;
				htp.br;
				
				htp.print('<a class="btn btn-success" style="font-size: 50px; margin-left: auto; margin-right: 10px;" href="ui_frmadd_membre" >Inscription</a>');
				htp.print('<a class="btn btn-primary" style="font-size: 50px; margin-right:auto;" href="login" >Connexion</a>');
				
				
				htp.print('</div>');
			end if;
			
		FOR i IN user_rights.FIRST .. user_rights.LAST
		LOOP
      			htp.print(user_rights(i));
   		END LOOP;
   			
		htp.bodyClose;
	htp.htmlClose;
	EXCEPTION
		WHEN OTHERS THEN
		htp.print(SQLCODE);
END;
/

CREATE OR REPLACE
PROCEDURE header
	(
	user_id in number,
	user_name in varchar2,
	user_type in varchar2,
	user_right in varchar2	
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN

	htp.bodyOpen;
			htp.print('<div class="container">');
			
			htp.print('<div style="display:block; background-color: #D3D3D3; height: 150px; border-radius: 3px; padding:10px;">');
				
			htp.print('<a href="hello" style="float: left">');
			htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="200px" style="margin-left:auto; margin-right: auto;" />');
			htp.print('</a>');
				
			htp.br;

			if (user_id >= 0)
			then 
				htp.print('<div style="float: right">Bonjour ' || user_name || '</div>');
				
				htp.br;
				htp.br;
				htp.br;
				
				if(user_right = 'D03')
				then
					htp.print('<a class="btn btn-info"  style="float: right" href="admin" >Administration</a>');
				
					if( user_type = 'E' and user_right = 'D03')
					then
						htp.print('<a class="btn btn-danger"  style="float: right; margin-right: 10px;" href="admin_expert" >Administration expert</a>');
					end if;
					
				elsif(user_type = 'null')
				then
					htp.print('Pas de droits administration');
				end if;
				
				htp.print('<a class="btn btn-primary" style="float: right; margin-right: 10px;" href="logout" >Déconnexion</a>');
				
				htp.print('</div>');

				htp.br;	
				htp.br;
				htp.br;

			else
				htp.br;
				htp.print('<a class="btn btn-success" style="float: right" href="ui_frmadd_membre" >Inscription</a>');
				htp.print('<a class="btn btn-primary" style="float: right; margin-right: 10px;" href="login" >Connexion</a>');
				
				htp.print('</div>');
			end if;
				
		htp.bodyClose;
	htp.htmlClose;
	EXCEPTION
		WHEN OTHERS THEN
		htp.print(SQLCODE);
END;
/

CREATE OR REPLACE
PROCEDURE get_info_user_right
   (
   user_right out varchar2
   )
IS
   cookie_lolita owa_cookie.cookie;
   user_id number(5);
BEGIN
           cookie_lolita := owa_cookie.get('user');

   if (cookie_lolita.num_vals > 0)
   then
           user_id  := cookie_lolita.vals(1);

           SELECT
                   A.code into user_right
           FROM
                   MEMBRE M Inner Join ATTRIBUER A
                   On M.nummembre = A.nummembre
           WHERE
                   M.nummembre = user_id
           AND
                   A.code = 'D03';
   end if;

   EXCEPTION
           WHEN NO_DATA_FOUND THEN
                   user_right := 'null';
END;
/


CREATE TYPE array_t AS TABLE OF VARCHAR2(5)
/

CREATE OR REPLACE
PROCEDURE get_info_user_rights
   (
   rights out array_t
   )
IS
   cookie_lolita owa_cookie.cookie;
   user_id number(5);
BEGIN
   cookie_lolita := owa_cookie.get('user');

   if (cookie_lolita.num_vals > 0)
   then
           user_id  := cookie_lolita.vals(1);

           SELECT
                   A.code 
                   BULK COLLECT INTO rights
           FROM
                   MEMBRE M Inner Join ATTRIBUER A
                   On M.nummembre = A.nummembre
           WHERE
                   M.nummembre = user_id;
   end if;
   
   EXCEPTION
           WHEN NO_DATA_FOUND THEN
                   htp.print(SQLCODE);
END;
/



CREATE OR REPLACE
PROCEDURE get_info_user
   (
   user_id out number,
   user_name out varchar2,
   user_type out varchar2
   )
IS
   cookie_lolita owa_cookie.cookie;
BEGIN
           cookie_lolita := owa_cookie.get('user');


   if (cookie_lolita.num_vals > 0)
   then
           user_id  := cookie_lolita.vals(1);
           SELECT
                   premembre || ' ' || nommembre, typmembre into user_name, user_type
           FROM
                   MEMBRE
           WHERE
                   nummembre = user_id;
   else
   	user_id := -1;
   end if;
   EXCEPTION
           WHEN NO_DATA_FOUND THEN
                   user_id := -1;
END;
/

