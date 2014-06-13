package fr.corbeau;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * @author Benjamin
 *
 */
@SuppressWarnings("nls")
public class Resource {

	
	public static final String css = "https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css";
	public static final String user_homepage = "hello";
	public static final String admin_homepage = "admin";

	
	/**
	 * 
	 */
	public static final Map<String, String> equivalence = new HashMap<String, String>();
	static
	{
		equivalence.put("<html>", "htp.htmlOpen;");
		equivalence.put("</html>", "htp.htmlClose;");
		equivalence.put("<head>", "htp.headOpen;");
		equivalence.put("</head>", "htp.headClose;");
		equivalence.put("<body>", "htp.bodyOpen;");
		equivalence.put("</body>", "htp.bodyClose;");
		equivalence.put("<br/>", "htp.br;");
		equivalence.put("<hr/>", "htp.hr;");
		
		equivalence.put("<table>", "htp.tableOpen;");
		equivalence.put("</table>", "htp.tableClose;");
		equivalence.put("<thead>", "");
		equivalence.put("</thead>", "");
		equivalence.put("<tbody>", "");
		equivalence.put("</tbody>", "");
		equivalence.put("<tr>", "htp.tableRowOpen;");
		equivalence.put("</tr>", "htp.tableRowClose;");
		
		
		
		// with elements
		equivalence.put("<title>.*</title>", "htp.title('");
		equivalence.put("<h1>.*</h1>", "htp.header(1,'");
		equivalence.put("<h2>.*</h2>", "htp.header(2,'");
		equivalence.put("<h3>.*</h3>", "htp.header(3,'");
		equivalence.put("<p>.*</p>", "htp.p('");
		equivalence.put("<!-- .* -->", "htp.comment('");
		
		equivalence.put("<th>.*</th>", "htp.tableHeader('");
		equivalence.put("<td>.*</td>", "htp.tableData('");
		
		
		// with attributes
		equivalence.put("<img (.*=\".*\")* />", "htp.img(");
		
		// with elements and attributes
		equivalence.put("<a (.*=\".*\")* >.*</a>", "htp.anchor(");
		
	}
	
	
	/**
	 * 
	 */
	public static final List<Pattern> listPatterns = new ArrayList<Pattern>();
	static
	{
		// with elements
		listPatterns.add(Pattern.compile("<title>.*</title>"));
		listPatterns.add(Pattern.compile("<h1>.*</h1>"));
		listPatterns.add(Pattern.compile("<h2>.*</h2>"));
		listPatterns.add(Pattern.compile("<h3>.*</h3>"));
		listPatterns.add(Pattern.compile("<p>.*</p>"));
		listPatterns.add(Pattern.compile("<!-- .* -->"));
		
		listPatterns.add(Pattern.compile("<th>.*</th>"));
		listPatterns.add(Pattern.compile("<td>.*</td>"));
		
		// with attributes
		// listPatterns.add(Pattern.compile("<img (.*=\".*\")* />"));
		
		
		// with elements and attributes
		// listPatterns.add(Pattern.compile("<a (.*=\".*\")* >.*</a>"));
		
	}
	
	
}
