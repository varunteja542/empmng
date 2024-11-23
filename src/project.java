import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class project extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("emp_id") == null) {
            out.println("<h3>You must be logged in to view projects.</h3>");
            return;
        }

        int empId = (int) session.getAttribute("emp_id");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT p.project_id, p.project_name, p.project_description, p.project_updates " +
                         "FROM projects p " +
                         "JOIN project_emp pe ON p.project_id = pe.project_id " +
                         "WHERE pe.emp_id = ? AND p.project_status = 'ongoing'";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, empId);
            rs = stmt.executeQuery();

            out.println("<html>");
            out.println("<head>");
            out.println("<title>Ongoing Projects</title>");
            out.println("<style>");
            out.println("table { border-collapse: collapse; width: 80%; margin: 20px auto; }");
            out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println(".btn { padding: 5px 10px; color: #fff; background-color: #007bff; border: none; border-radius: 3px; cursor: pointer; }");
            out.println(".btn:hover { background-color: #0056b3; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h2 style='text-align:center;'>Ongoing Projects</h2>");
            out.println("<table>");
            out.println("<tr><th>Project ID</th><th>Project Name</th><th>Description</th><th>Updates</th><th>Action</th></tr>");

            while (rs.next()) {
                int projectId = rs.getInt("project_id");
                String projectName = rs.getString("project_name");
                String projectDescription = rs.getString("project_description");
                String projectUpdates = rs.getString("project_updates");

                out.println("<tr>");
                out.println("<td>" + projectId + "</td>");
                out.println("<td>" + projectName + "</td>");
                out.println("<td>" + projectDescription + "</td>");
                out.println("<td>" + projectUpdates + "</td>");
                out.println("<td>");

        
                
                out.println("<form action='up' method='post' style='margin: 0;'>");
                out.println("<input type='hidden' name='project_id' value='" + projectId + "'>");
                out.println("<input type='text' name='update' placeholder='Enter update' required>");
                out.println("<button type='submit' class='btn'>Update</button>");
                out.println("</form>");
                out.println("</td>");
                
                out.println("<td>");
                out.println("<form action='complete' method='post' style='margin: 0;'>");
                out.println("<input type='hidden' name='project_id' value='" + projectId + "'>");
                out.println("<label for='complete'>Complete</label>");
                out.println("<input type='checkbox' name='complete' value='true'>");
                out.println("<button type='submit' class='btn'>Mark as Completed</button>");
                out.println("</form>");
                out.println("</td>");
                
 
                out.println("</tr>");
            }

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
