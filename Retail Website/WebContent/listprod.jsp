<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>WE THE BEST</title>
</head>
<body>

<h1>YOUR QUEST FOR YOUR KEY TO SUCCESS STARTS HERE:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="name" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<%
	// Note: Forces loading of SQL Server driver
	try
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}

	// Get product name to search for
	String name = request.getParameter("name");
	boolean hasParameter = false;
	String sql = "";

	if (name == null)
		name = "";

	if (name.equals("")) 
	{
		out.println("<h2>All Products</h2>");
		sql = "SELECT pid, name, price FROM KeyToSuccess";
	} 
	else 
	{
		out.println("<h2>Products containing '" + name + "'</h2>");
		hasParameter = true;
		sql = "SELECT pid, name, price FROM KeyToSuccess WHERE name LIKE ?";
		name = '%' + name + '%';
	}

	Connection con = null;
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_nvyas;";
	String uid = "nvyas";
	String pw = "37777133";
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	try 
	{
		con = DriverManager.getConnection(url, uid, pw);
		PreparedStatement pstmt = con.prepareStatement(sql);
		if (hasParameter)
			pstmt.setString(1, name);

		ResultSet rst = pstmt.executeQuery();
		out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Price</th></tr>");
		while (rst.next()) 
		{
			out.print("<tr><td>"+rst.getInt(1)+"</td>"+
					  "<td>"+rst.getString(2)+"</td>"+
					  "<td>"+currFormat.format(rst.getDouble(3))+"</td>"+
					  "<td><a href=\"addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2)
					+ "&price=" + rst.getDouble(3) + "\">Add to Cart</a><td></tr>");
		}
		out.println("</table>");
	} 
	catch (SQLException ex) 
	{
		out.println(ex);
	} 
	finally 
	{
		try 
		{
			if (con != null)
				con.close();
		} 
		catch (SQLException ex) 
		{
			out.println(ex);
		}
	}
%>
</body>
</html>