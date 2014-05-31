package fr.corbeau;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

		proceduresSQL.put("ui_frmadd", uiFrmadd(names, types, tableName));
		proceduresSQL.put("ui_execadd", uiExeadd(names, types, tableName));
		proceduresSQL.put("pa_add", paAdd(names, types, tableName));

		
		return proceduresSQL;
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
	 * INSERT command
	 * 
	 * @param names		a list with the name of the parameters
	 * @param types		a list with the type of parameters
	 * @param tableName	the name of the table
	 * @return			the INSERT command
	 */
	public static String paAdd(List<String> names, List<String> types, String tableName) {

		String code = "CREATE OR REPLACE PROCEDURE pa_add_" + tableName;
		code += "\n\t(";

		for (int i=0; i<names.size(); i++) {
			code += "\n\t\t" + names.get(i) + " in " + getPLType(types.get(i));
			if (i+1 != names.size())
				code += ",";
		}

		code += "\n\t)\n";
		code += "IS\nBEGIN\n";
		code += "\tINSERT INTO " + tableName + " VALUES";
		code += "\n\t(";

		for (int i=0; i<names.size(); i++) {
			code += "\n\t\t" + names.get(i) + "";
			if (i+1 != names.size())
				code += ",";
		}

		code += "\n\t);\n";
		code += "COMMIT;\n";
		code += "END;\n";
		code += "/";

		return code;
	}




	/**
	 * @param names a list with the name of the parameters
	 * @param types a list with the name of the parameters
	 * @param tableName the name of the table
	 * @return	the form
	 */
	public static String uiFrmadd(List<String> names, List<String> types, String tableName) {

		List<String> body = new ArrayList<String>();

		String code = "CREATE OR REPLACE PROCEDURE ui_frmadd_" + tableName;
		code += "\nIS";
		code += "\nBEGIN";

		body.add("htp.htmlOpen");
		body.add("htp.headOpen");
		body.add("htp.title('Insertion " + tableName + "');");
		body.add("htp.headClose");
		body.add("htp.bodyOpen");

		body.add("htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_"+tableName+"', 'POST');");	
		body.add("htp.tableOpen;");

		body.add("htp.tableRowOpen");
		body.add("htp.tableHeader('');");
		body.add("htp.tableHeader('Saisir les valeurs');");
		body.add("htp.tableRowClose;");

		for (int i=0; i<names.size(); i++) {
			body.add("htp.tableRowOpen;");
			body.add("htp.tableData('"+names.get(i)+"');");
			body.add("htp.tableData(htf.formText('"+names.get(i)+"', "+getLengthType(types.get(i))+"));");
			body.add("htp.tableRowClose;");
		}
		
		body.add("htp.tableRowOpen;");
		body.add("htp.tableData('Validation :')");
		body.add("htp.tableData(htf.formSubmit(NULL, 'Insertion'))");
		body.add("htp.tableRowClose;");

		body.add("htp.tableClose;");
		body.add("htp.formClose;");
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
	 * Get the length of the type of the variable
	 * 
	 * @param type	the complete type (eg varchar(45))
	 * @return	the length (eg 45)
	 */
	public static int getLengthType(String type) {
		
		if(type.equals("date"))
			return 10;

		return Integer.parseInt(type.substring(type.indexOf("(")+1, type.indexOf(")")));
	}


	/**
	 * @param names a list with the name of the parameters
	 * @param types a list with the type of the parameters
	 * @param tableName the name of the table
	 * @return the confirmation message
	 */
	public static String uiExeadd(List<String> names, List<String> types, String tableName) {
		
		List<String> body = new ArrayList<String>();

		String code = "CREATE OR REPLACE PROCEDURE ui_execadd_" + tableName;
		
		code += "\n\t(";
		for (int i=0; i<names.size(); i++) {
			code += "\n\t\t" + names.get(i) + " in " + getPLType(types.get(i));
			if (i+1 != names.size())
				code += ",";
		}
		code += "\n\t)\n";
		
		code += "\nIS";
		code += "\nBEGIN";

		body.add("htp.htmlOpen");
		body.add("htp.headOpen");
		body.add("htp.title('Insertion " + tableName + "');");
		body.add("htp.headClose");
		body.add("htp.bodyOpen");
		
		body.add(addSQLFunctionInExec(names, tableName));
						
		body.add("htp.br;");
		body.add("htp.print('Ajout effectué dans la table "+tableName+"')");
		
		body.add("htp.bodyClose;");
		body.add("htp.htmlClose;");
		
		for (String line : body) {
			code += "\n\t" + line;
		}
		
		
		code += "\nEXCEPTION";
		code += "\n\tWHEN OTHERS THEN";
		
		code += "\n\t\thtp.print('ERROR: ' || SQLCODE);";
		
		code += "\nEND;";
		code += "\n/";
		
		return code;
	}

	
	/**
	 * Simple method to add the call to the PL/SQL procedure of the SQL function 
	 * 
	 * @param names		a list with the name of the parameters 
	 * @param tableName	the name of the table
	 * @return	string with the call to the procedure
	 */
	public static String addSQLFunctionInExec(List<String> names, String tableName) {
		
		String code = "pa_add_" + tableName + "(";
		for (int i=0; i<names.size(); i++) {
			code += names.get(i);
			if (i+1 != names.size())
				code += ",";
		}
		code += ");";
		
		return code;
	}
	
}
