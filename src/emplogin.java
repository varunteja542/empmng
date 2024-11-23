import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class emplogin extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String password = request.getParameter("pass");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            String sql = "SELECT emp_id, password FROM empp WHERE email = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                if (dbPassword.equals(password)) {
                   
                    int id = rs.getInt("emp_id");

                    
                    HttpSession session = request.getSession();
                    session.setAttribute("emp_id", id);

                    
                    response.sendRedirect("empprof.html");
                } else {
                    
                    out.println("<h3>Invalid credentials. Please try again.</h3>");
                    response.sendRedirect("login.html");
                }
            } else {
                
                out.println("<h3>Email not registered. Please sign up first.</h3>");
                response.sendRedirect("signup.html");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<h3>Internal error occurred. Please try again later.</h3>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
