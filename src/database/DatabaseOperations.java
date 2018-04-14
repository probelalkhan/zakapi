package database;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.sql.*;


public class DatabaseOperations {

    private Connection conn;

    public DatabaseOperations() throws SQLException, ClassNotFoundException {
        Class.forName(DatabaseConstants.JDBC_DRIVER);
        conn = DriverManager.getConnection(DatabaseConstants.DB_URL, DatabaseConstants.USER, DatabaseConstants.PASS);
    }

    public int registerUser(String username, String password) throws SQLException {
        if (isUserExist(username)) {
            return DatabaseConstants.USER_ALREADY_EXIST;
        } else {

            PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (username, password) VALUES (?, ?)");
            stmt.setString(1, username);
            stmt.setString(2, password);
            int registered = stmt.executeUpdate();
            stmt.close();
            if (registered == 1)
                return DatabaseConstants.USER_REGISTERED;
            else
                return DatabaseConstants.USER_REGISTRATION_FAILED;
        }
    }

    public boolean setTemperatureMinMax(int t1_min, int t1_max, int t2_min, int t2_max) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("UPDATE tempconst SET t1_min = ?, t1_max = ?, t2_min = ?, t2_max = ?");
        stmt.setInt(1, t1_min);
        stmt.setInt(2, t1_max);
        stmt.setInt(3, t2_min);
        stmt.setInt(4, t2_max);
        return stmt.executeUpdate() == 1;
    }


    public boolean setPressureMinMax(int p1_min, int p1_max, int p2_min, int p2_max) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("UPDATE pressconst SET p1_min = ?, p1_max = ?, p2_min = ?, p2_max = ?");
        stmt.setInt(1, p1_min);
        stmt.setInt(2, p1_max);
        stmt.setInt(3, p2_min);
        stmt.setInt(4, p2_max);
        return stmt.executeUpdate() == 1;
    }

    public int[] getTemperatureMinMax() throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("SELECT t1_min, t1_max, t2_min, t2_max FROM tempconst");
        ResultSet rs = stmt.executeQuery();
        int[] values = new int[4];

        if (rs.first()) {
            values[0] = rs.getInt(1);
            values[1] = rs.getInt(2);
            values[2] = rs.getInt(3);
            values[3] = rs.getInt(4);
        }

        return values;
    }


    public int[] getPressureMinMax() throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("SELECT p1_min, p1_max, p2_min, p2_max FROM pressconst");
        ResultSet rs = stmt.executeQuery();
        int[] values = new int[4];
        if (rs.first()) {
            values[0] = rs.getInt(1);
            values[1] = rs.getInt(2);
            values[2] = rs.getInt(3);
            values[3] = rs.getInt(4);
        }
        return values;
    }


    public JSONObject userLogin(String username, String password) throws SQLException, JSONException {
        PreparedStatement stmt = conn.prepareStatement("SELECT id, username FROM users WHERE username = ? AND password = ?");
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.first()) {
            JSONObject obj = new JSONObject();
            obj.put("id", rs.getString(1));
            obj.put("username", rs.getString(2));
            return obj;
        }
        return null;
    }

    public JSONArray getTemperatures() throws SQLException, JSONException {
        PreparedStatement stmt = conn.prepareStatement("SELECT id, temperature1, temperature2, date FROM temperatures ORDER BY date DESC LIMIT 60");

        ResultSet rs = stmt.executeQuery();
        JSONArray array = new JSONArray();
        if (rs.first()) {
            do {
                JSONObject temp = new JSONObject();
                temp.put("id", rs.getInt(1));
                temp.put("temperature1", rs.getFloat(2));
                temp.put("temperature2", rs.getFloat(3));
                temp.put("date", rs.getTimestamp(4));
                array.put(temp);
            } while (rs.next());
        }
        return array;
    }

    public JSONArray getPressures() throws SQLException, JSONException {
        PreparedStatement stmt = conn.prepareStatement("SELECT id, pressure1, pressure2, date FROM pressures ORDER BY date DESC LIMIT 60");

        ResultSet rs = stmt.executeQuery();
        JSONArray array = new JSONArray();
        if (rs.first()) {
            do {
                JSONObject temp = new JSONObject();
                temp.put("id", rs.getInt(1));
                temp.put("pressure1", rs.getFloat(2));
                temp.put("pressure2", rs.getFloat(3));
                temp.put("date", rs.getTimestamp(4));
                array.put(temp);
            } while (rs.next());
        }
        return array;
    }

    private boolean isUserExist(String username) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        return rs.first();
    }
}
