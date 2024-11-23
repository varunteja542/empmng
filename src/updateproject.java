import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class updateproject extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Fetch parameters
        String update = request.getParameter("update");
        int projectId = Integer.parseInt(request.getParameter("project_id"));

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update project updates
            String sql = "UPDATE projects SET project_updates = CONCAT(IFNULL(project_updates, ''), ?, '\n') WHERE project_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "- " + update);
            stmt.setInt(2, projectId);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                
                
                response.sendRedirect("projects.html");
            } 
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<h3>Internal error occurred. Please try again later.</h3>");
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
