package org.fisi.iot.pe.iotproject.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtil {
    public static final String FORMAT_DATE = "dd/MM/yyyy";
    public static final String FORMAT_HOUR = "HH:mm";
    public static final String FORMAT_DATE_HOUR = "dd/MM/yyyy HH:mm";
    public static final String FORMAT_DATE_HYPHEN = "dd-MM-yyyy";
    public static final String FORMAT_DATE_HOUR_HYPHEN = "dd-MM-yyyy HH:mm";
    public static final String FORMAT_DATE_HOUR_MIN = "yyyy-MM-dd HH:mm";
    public static final String FORMAT_DATE_XML = "yyyy-MM-dd";
    public static final String FORMAT_DATE_RFC = "dd.MM.yyyy";
    public static final String FORMAT_DATE_ISO_8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX";
    public static final String FORMAT_DATE_FRACTAL = "yyyy-MM-dd'T'HH:mm:ss";


    public static Date convertStringToDate(String strDate, String format) {
        Date date = null;
        try {
            SimpleDateFormat formatter = new SimpleDateFormat(format);
            date = formatter.parse(strDate);
        } catch (Exception e) {
        }
        return date;
    }

    public static String convertDateToString(Date date, String format) {
        String strDate = "";
        try {
            SimpleDateFormat formatter = new SimpleDateFormat(format);
            strDate = formatter.format(date);
        } catch (Exception e) {
            strDate = "";
        }
        return strDate;
    }

    public static String changeStringDateFormat(String strDateInput, String formatInput, String formatOutput) {
        Date tempDate = convertStringToDate(strDateInput, formatInput);
        return convertDateToString(tempDate, formatOutput);
    }

    public static String getCurrentYearAsString() {
        return String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
    }

    public static String getYearAsString(Date now) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
        return formatter.format(now);
    }

    public static String getCurrentYearMonthAsString() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
        return formatter.format(new Date());
    }

    public static String getYearMonthAsString(Date now) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
        return formatter.format(now);
    }
    public static String getFullDate(Date date){
        String dateToString = "";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("EEEE dd 'de' MMMM 'de' YYYY", new Locale("es", "ES"));
            dateToString = sdf.format(date);
        } catch (Exception ex){
            dateToString = "";
        }
        return dateToString;
    }


    public static String getDateForSubjects(Date date){
        String dateToString = "";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("EEEE dd 'de' MMMM", new Locale("es", "ES"));
            dateToString = sdf.format(date);
        } catch (Exception ex){
            dateToString = "";
        }
        return dateToString;
    }
    public static Date getBeginningOfDay(){
        Calendar calendar = Calendar.getInstance();


        calendar.set(Calendar.YEAR, calendar.get(Calendar.YEAR));
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
        calendar.set(Calendar.DATE, calendar.get(Calendar.DATE));
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date date = calendar.getTime();
        return date;
    }
    public static Date sumarDiasAFecha(Date fecha, int dias){
        if (dias==0) return fecha;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(fecha);
        calendar.add(Calendar.DAY_OF_YEAR, dias);
        return calendar.getTime();
    }

    public static Integer getYear(Date fecha){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(fecha);
        return calendar.get(Calendar.YEAR);
    }
    public static Date maximizarFecha(Date fecha) {
        if (fecha != null) {
            Calendar date = Calendar.getInstance();
            date.setTime(fecha);
            date.set(Calendar.HOUR, date.getMaximum(Calendar.HOUR_OF_DAY));
            date.set(Calendar.MINUTE, date.getMaximum(Calendar.MINUTE));
            date.set(Calendar.SECOND, date.getMaximum(Calendar.SECOND));
            date.set(Calendar.MILLISECOND, date.getMaximum(Calendar.MILLISECOND));
            return date.getTime();
        }
        return fecha;
    }
    public static Date endOfDay(String date, String format){
        Date fecha = convertStringToDate(date, format);
        return maximizarFecha(fecha);
    }
    public static Date initOfDay(String date, String format){
        Date fecha = convertStringToDate(date, format);
        return minimizarFecha(fecha);
    }
    public static Date minimizarFecha(Date fecha) {
        if (fecha != null) {
            Calendar date = Calendar.getInstance();
            date.setTime(fecha);
            date.set(Calendar.HOUR, date.getMinimum(Calendar.HOUR_OF_DAY));
            date.set(Calendar.MINUTE, date.getMinimum(Calendar.MINUTE));
            date.set(Calendar.SECOND, date.getMinimum(Calendar.SECOND));
            date.set(Calendar.MILLISECOND, date.getMinimum(Calendar.MILLISECOND));
            return date.getTime();
        }
        return fecha;
    }
    public static Date endOfDay(){
        Calendar calendar = Calendar.getInstance();


        calendar.set(Calendar.YEAR, calendar.get(Calendar.YEAR));
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
        calendar.set(Calendar.DATE, calendar.get(Calendar.DATE));
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        Date date = calendar.getTime();
        return date;
    }
}
