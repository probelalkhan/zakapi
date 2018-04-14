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
    <title>Set Temperaturre Min Max</title>
</head>
<body>

<%
    DatabaseOperations db = new DatabaseOperations();
    String result = "";
    int[] values = new int[4];
    try {
        values = db.getTemperatureMinMax();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    if (request.getMethod().equalsIgnoreCase("post")) {
        int t1_min = Integer.parseInt(request.getParameter("t1_min"));
        int t1_max = Integer.parseInt(request.getParameter("t1_max"));
        int t2_min = Integer.parseInt(request.getParameter("t2_min"));
        int t2_max = Integer.parseInt(request.getParameter("t2_max"));

        try {
            if (db.setTemperatureMinMax(t1_min, t1_max, t2_min, t2_max)) {
                result = "Values are saved";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

%>

<form method="POST" action="temperature.jsp">
    <div>
        <label for="t1_min">t1 min</label>
        <input id="t1_min" type="number" name="t1_min" placeholder="t1 min" value="<% out.print(values[0]);%>"
               required/>
    </div>
    <div>
        <label for="t1_max">t1 max</label>

        <input id="t1_max" type="number" name="t1_max" placeholder="t1 max" value="<% out.print(values[1]);%>"
               required/>
    </div>
    <div>
        <label for="t2_min">t2 min</label>
        <input id="t2_min" type="number" name="t2_min" placeholder="t2 min" value="<% out.print(values[2]);%>"
               required/>
    </div>
    <div>
        <label for="t2_max">t2 max</label>
        <input id="t2_max" type="number" name="t2_max" placeholder="t2 max" value="<% out.print(values[3]);%>"
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
