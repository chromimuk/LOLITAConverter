package fr.corbeau;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import fr.corbeau.sql.Delete;
import fr.corbeau.sql.Insert;
import fr.corbeau.sql.Update;

/**
 * Methods to convert a SQL file to a PL/SQL Web Toolkit code
 * 
 * @author Benjamin
 *
 */
public class SQLConverter {



	/**
	 * From the SQL code, converts it to PL/SQL Web Toolkit code
	 * 
	 * @param SQLCode		the SQL code
	 * @param tableName		the name of the table
	 * @return the PL/SQL code
	 */
	public static Map<String, String> convertSQLToPL(List<String> SQLCode, String tableName) {

		Pattern pattern = Pattern.compile("^$|^--|^DROP|^CREATE|^CONSTRAINT|\\);|\\($");

		List<String> names = new ArrayList<String>();
		List<String> types = new ArrayList<String>();

		for (String line : SQLCode) {

			Matcher matcher = pattern.matcher(line);

			if (!matcher.find()) {
				String[] l = line.split(" ");
				names.add("v" + l[0].toLowerCase());
				types.add(l[1].toLowerCase());
			}

		}

		
		Map<String, String> proceduresSQL = new HashMap<String, String>();

		// show
		proceduresSQL.put("afft", afft(names, types, tableName));

		// insert
		proceduresSQL.put("pa_add", Insert.paAdd(names, types, tableName));
		proceduresSQL.put("ui_execadd", Insert.uiExecadd(names, types, tableName));
		proceduresSQL.put("ui_frmadd", Insert.uiFrmadd(names, types, tableName));

		// update
		proceduresSQL.put("pa_edit", Update.paEdit(names, types, tableName));
		proceduresSQL.put("ui_execedit", Update.uiExecedit(names, types, tableName));
		proceduresSQL.put("ui_frmedit", Update.uiFrmedit(names, types, tableName));
		
		// delete
		proceduresSQL.put("pa_del", Delete.paDel(names, types, tableName));
		proceduresSQL.put("ui_execdel", Delete.uiExecdel(names, types, tableName));
		
		
		System.out.println(Delete.paDel(names, types, tableName));
		System.out.println(Delete.uiExecdel(names, types, tableName));
		
		return proceduresSQL;
	}

	
	

	private static String afft(List<String> names, List<String> types, String tableName) {

		List<String> body = new ArrayList<String>();

		String code = "CREATE OR REPLACE PROCEDURE afft_" + tableName;
		code += "\nIS";
		code += "\nrep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';";
		
		code += "\nCURSOR lst IS SELECT * FROM " + tableName.toUpperCase() + ";"; 
		
		code += "\nBEGIN";

		body.add("htp.print('<!DOCTYPE html>');");
		body.add("htp.htmlOpen;");
		body.add("htp.headOpen;");
		body.add("htp.title('Table " + tableName + "');");
		body.add("htp.print('<link href=\"' || rep_css || '\" rel=\"stylesheet\" type=\"text/css\" />');");
		body.add("htp.headClose;");
		body.add("htp.bodyOpen;");
		
		body.add("htp.print('<div class=\"container\">');");
		
		body.add("htp.header(1, 'LOLITA');");
		body.add("htp.hr;");
		body.add("htp.header(2, 'Liste "+ tableName + "');");

		body.add("htp.print('<table class=\"table\">');");
		body.add("htp.tableRowOpen;");
		body.add("htp.tableHeader('Numero');");
		body.add("htp.tableRowClose;");
		body.add("FOR rec IN lst loop");
		body.add("htp.tableRowOpen;");
		
		for (int i=0; i<names.size(); i++) {
			body.add("htp.tableData(rec."+names.get(i).substring(1)+");");
		}
		
		body.add("htp.tableRowClose;");
		body.add("END LOOP;");
		body.add("htp.tableClose;");

		body.add("htp.print('</div>');");
		body.add("htp.bodyClose;");
		body.add("htp.htmlClose;");


		for (String line : body) {
			code += "\n\t" + line;
		}
		code += "\nEND;";
		code += "\n/";
		
		return code;
	}

	
	
	/**
	 * Transform the SQL type to the equivalent in PL/SQL
	 * 
	 * @param type		the type
	 * @return			the equivalent type
	 */
	public static String getPLType(String type) {

		String code = type;

		if (type.indexOf("(") > -1)
			code = type.substring(0, type.indexOf("("));

		return code;
	}
	
	
}
