package database;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Test{

    public static void main(String[] s){

        String myDate = "2017-09-25 20:16:08.0";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = null;
        try {
            date = sdf.parse(myDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        long millis = date.getTime();
        System.out.println(millis);
    }
}
