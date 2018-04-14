<%@ page import="database.DatabaseConstants"%><%@ page import="database.DatabaseOperations"%><%@ page import="org.json.JSONObject"%><%@ page import="java.sql.SQLException"%><%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    DatabaseOperations db = new DatabaseOperations();

    JSONObject obj = new JSONObject();

    if(request.getParameter("apicall")!=null){

        if(request.getParameter("apicall").equalsIgnoreCase("register")){

            if(request.getMethod().equalsIgnoreCase("post")){
                String[] params = {"username","password"};
                String validation = validateParameters(params, request);

                if(validation != null){
                    obj.put("error", true);
                    obj.put("message", "Required params "+ validation + " not available");
                }else{
                    try {
                        int registered = db.registerUser(request.getParameter("username"), request.getParameter("password"));
                        if(registered == DatabaseConstants.USER_REGISTERED){
                            obj.put("error", false);
                            obj.put("message", "User registered successfully");
                        }else if (registered == DatabaseConstants.USER_ALREADY_EXIST){
                            obj.put("error", true);
                            obj.put("message", "The username is already taken");
                        }else{
                            obj.put("error", true);
                            obj.put("message", "Some error occurred please try again!!");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println(e.getMessage());
                    }
                }

            }else{
                obj.put("error", true);
                obj.put("message", "Invalid Call");
            }
        }

        if(request.getParameter("apicall").equalsIgnoreCase("login")){
            if(request.getMethod().equalsIgnoreCase("post")){
                String[] params = {"username","password"};
                String validation = validateParameters(params, request);

                if(validation != null){
                    obj.put("error", true);
                    obj.put("message", "Required params "+ validation + " not available");
                }else{
                    try {
                        JSONObject user = db.userLogin(request.getParameter("username"), request.getParameter("password"));

                        if(user!=null){
                            obj.put("error", false);
                            obj.put("user", user);

                        }else{
                            obj.put("error", true);
                            obj.put("message", "Invalid username or password");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println(e.getMessage());
                    }
                }

            }else{
                obj.put("error", true);
                obj.put("message", "Invalid Call");
            }
        }

        if(request.getParameter("apicall").equalsIgnoreCase("temperature")){
            try{
                obj.put("error", false);
                obj.put("temperatures", db.getTemperatures());
            }catch (SQLException e){

            }
        }

        if(request.getParameter("apicall").equalsIgnoreCase("pressure")){
            try{
                obj.put("error", false);
                obj.put("pressures", db.getPressures());
            }catch (SQLException e){

            }
        }

        if(request.getParameter("apicall").equalsIgnoreCase("minmax")){
            try{
                obj.put("error", false);
                int[] tempVals = db.getTemperatureMinMax();
                int[] pressVals = db.getTemperatureMinMax();
                obj.put("temp", tempVals);
                obj.put("press", pressVals);
            }catch (SQLException e){}
        }

    }else{
        obj.put("error",true);
        obj.put("message", "Invalid API Call");
    }


    out.println(obj.toString());

%>

<%!
    private String validateParameters(String[] params, HttpServletRequest request){
        StringBuilder sb = new StringBuilder();
        boolean validated = true;
        for(String s: params){
            if(request.getParameter(s)==null || request.getParameter(s).trim().length()<=0){
                sb.append(s + ", ");
                validated = false;
            }
        }
        if(validated){
            return null;
        }else{
            return sb.substring(0, sb.length() - 2);
        }
    }
%>