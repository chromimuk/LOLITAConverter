package fr.corbeau;

import java.lang.Character.Subset;
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
	public static Map<String, Map> convertSQLToPL(List<String> SQLCode, String tableName) {

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


		Map<String, Map> proceduresSQL = new HashMap<String, Map>();
		Map<String, String> show = new HashMap<String, String>();
		Map<String, String> insert = new HashMap<String, String>();
		Map<String, String> update = new HashMap<String, String>();
		Map<String, String> delete = new HashMap<String, String>();


		// show
		show.put("afft_"+tableName, afft(names, types, tableName));

		// insert
		insert.put("pa_add_"+tableName, Insert.paAdd(names, types, tableName));
		insert.put("ui_execadd_"+tableName, Insert.uiExecadd(names, types, tableName));
		insert.put("ui_frmadd_"+tableName, Insert.uiFrmadd(names, types, tableName));

		// update
		update.put("pa_edit_"+tableName, Update.paEdit(names, types, tableName));
		update.put("ui_execedit_"+tableName, Update.uiExecedit(names, types, tableName));
		update.put("ui_frmedit_"+tableName, Update.uiFrmedit(names, types, tableName));

		// delete
		delete.put("pa_del_"+tableName, Delete.paDel(names, types, tableName));
		delete.put("ui_execdel_"+tableName, Delete.uiExecdel(names, types, tableName));


		proceduresSQL.put("show", show);
		proceduresSQL.put("insert", insert);
		proceduresSQL.put("update", update);
		proceduresSQL.put("delete", delete);


		return proceduresSQL;
	}




	private static String afft(List<String> names, List<String> types, String tableName) {

		List<String> body = new ArrayList<String>();

		String code = "CREATE OR REPLACE";
		code += "\nPROCEDURE afft_" + tableName;
		code += "\nIS";
		code += "\n\trep_css varchar2(255) := "+Resource.css+";";

		code += "\n\tCURSOR lst";
		code += "\n\tIS \n\tSELECT \n\t\t *";
		code += "\n\tFROM \n\t\t" + tableName.toUpperCase() + ";"; 

		code += "\nBEGIN";

		body.add("htp.print('<!DOCTYPE html>');");
		body.add("htp.htmlOpen;");
		body.add("htp.headOpen;");
		body.add("htp.title('Affichage table " + tableName + "');");
		body.add("htp.print('<link href=\"' || rep_css || '\" rel=\"stylesheet\" type=\"text/css\" />');");
		body.add("htp.headClose;");
		body.add("htp.bodyOpen;");

		body.add("htp.print('<div class=\"container\">');");

		body.add("htp.header(1, 'LOLITA');");
		body.add("htp.hr;");
		body.add("htp.header(2, 'Liste "+ tableName + "');");

		body.add("htp.print('<table class=\"table\">');");
		body.add("htp.tableRowOpen(cattributes => 'class=active');");
		body.add("htp.tableHeader('Numéro');");
		body.add("htp.tableRowClose;");
		body.add("FOR rec IN lst LOOP");
		body.add("htp.tableRowOpen;");

		for (int i=0; i<names.size(); i++) {
			body.add("htp.tableData(rec."+names.get(i).substring(1)+");");
		}

		body.add(addActions(tableName, names.get(0)));

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



	public static String addActions(String tableName, String id) {

		String code = "htp.tableData(";

		code += "\n\t\thtf.anchor('ui_frmedit_"+tableName+"?"+id+"=' || rec."+id.substring(1)+", 'Modifier')";
		code += "\n\t\t|| ' ou ' ||";
		code += "\n\t\thtf.anchor('ui_execdel_"+tableName+"?"+id+"=' || rec."+id.substring(1)+", 'Supprimer')";
		
		code += "\n\t);";

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


	/**
	 * Simple method to add the call to the PL/SQL procedure of the SQL function 
	 * 
	 * @param names		a list with the name of the parameters 
	 * @param tableName	the name of the table
	 * @return	string with the call to the procedure
	 */
	public static String addSQLFunctionInExec(String function, List<String> names, String tableName) {

		String code = "pa_" + function  + "_" + tableName + "(";

		for (int i=0; i<names.size(); i++) {
			code += names.get(i);
			if (i+1 != names.size())
				code += ",";
		}
		code += ");";

		return code;
	}


	/**
	 * Get the length of the type of the variable
	 * 
	 * @param type	the complete type (eg varchar(45))
	 * @return	the length (eg 45)
	 */
	public static int getLengthType(String type) {

		if(type.equals("date"))
			return 10;
		else if(type.equals("clob"))
			return 1000;

		return Integer.parseInt(type.substring(type.indexOf("(")+1, type.indexOf(")")));
	}

}
