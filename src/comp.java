import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class comp extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("emp_id") == null) {
            out.println("<h3>You must be logged in to post a complaint.</h3>");
            return;
        }

        int empId = (int) session.getAttribute("emp_id");
        String complaint = request.getParameter("complaint");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "INSERT INTO complaints (complaint, emp_id) VALUES (?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, complaint);
            stmt.setInt(2, empId);
            stmt.executeUpdate();

          
            out.println("<html>");
            out.println("<head>");
            out.println("<script type='text/javascript'>");
            out.println("alert('Complaint posted successfully!');");
            out.println("window.location.href = 'comp.html';");  
            out.println("</script>");
            out.println("</head>");
            out.println("<body>");
            out.println("</body>");
            out.println("</html>");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<h3>Internal error occurred. Please try again later.</h3>");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("emp_id") == null) {
            out.println("<h3>You must be logged in to view complaints.</h3>");
            return;
        }

        int empId = (int) session.getAttribute("emp_id");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Query to fetch complaints along with their responses
            String sql = "SELECT c.complaint, c.response FROM complaints c WHERE c.emp_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, empId);
            rs = stmt.executeQuery();

            out.println("<html>");
            out.println("<head><title>Your Complaints</title></head>");
            out.println("<body>");
            out.println("<h3>Your Complaints</h3>");
            out.println("<table class='complaints-table'>");
            out.println("<thead><tr><th>Complaint</th><th>Response</th></tr></thead>");
            out.println("<tbody>");

            while (rs.next()) {
                String complaintText = rs.getString("complaint");
                String responseText = rs.getString("response");

                out.println("<tr>");
                out.println("<td>" + complaintText + "</td>");
                if (responseText != null) {
                    out.println("<td class='response'>" + responseText + "</td>");
                } else {
                    out.println("<td>No response yet</td>");
                }
                out.println("</tr>");
            }

            out.println("</tbody>");
            out.println("</table>");
            out.println("</body>");
            out.println("</html>");

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
