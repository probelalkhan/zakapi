<%--
  Created by IntelliJ IDEA.
  User: Belal
  Date: 4/13/2018
  Time: 10:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="database.DatabaseOperations" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Set Pressure Min Max</title>
</head>
<body>

<%
    DatabaseOperations db = new DatabaseOperations();
    String result = "";
    int[] values = new int[4];
    try {
        values = db.getPressureMinMax();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    if (request.getMethod().equalsIgnoreCase("post")) {
        int p1_min = Integer.parseInt(request.getParameter("p1_min"));
        int p1_max = Integer.parseInt(request.getParameter("p1_max"));
        int p2_min = Integer.parseInt(request.getParameter("p2_min"));
        int p2_max = Integer.parseInt(request.getParameter("p2_max"));

        try {
            if (db.setPressureMinMax(p1_min, p1_max, p2_min, p2_max)) {
                result = "Values are saved";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

%>

<form method="POST" action="pressure.jsp">
    <div>
        <label for="p1_min">p1 min</label>
        <input id="p1_min" type="number" name="p1_min" placeholder="p1 min" value="<% out.print(values[0]);%>"
               required/>
    </div>
    <div>
        <label for="p1_max">p1 max</label>

        <input id="p1_max" type="number" name="p1_max" placeholder="p1 max" value="<% out.print(values[1]);%>"
               required/>
    </div>
    <div>
        <label for="p2_min">p2 min</label>
        <input id="p2_min" type="number" name="p2_min" placeholder="p2 min" value="<% out.print(values[2]);%>"
               required/>
    </div>
    <div>
        <label for="p2_max">p2 max</label>
        <input id="p2_max" type="number" name="p2_max" placeholder="p2 max" value="<% out.print(values[3]);%>"
               required/>
    </div>

    <div>
        <button>Save</button>
    </div>

    <div>
        <%
            out.println(result);
        %>
    </div>
</form>

</body>
</html>
