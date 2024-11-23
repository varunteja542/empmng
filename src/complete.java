import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class complete extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        int projectId = Integer.parseInt(request.getParameter("project_id"));
        boolean complete = "true".equals(request.getParameter("complete"));

        if (complete) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                // Mark the project as completed
                String updateProjectStatusSql = "UPDATE projects SET project_status = 'completed' WHERE project_id = ?";
                stmt = conn.prepareStatement(updateProjectStatusSql);
                stmt.setInt(1, projectId);
                stmt.executeUpdate();

                // Move the project from running_projects to completed_projects
                String moveProjectSql = "INSERT INTO completed_projects (project_id) SELECT project_id FROM running_projects WHERE project_id = ?";
                stmt = conn.prepareStatement(moveProjectSql);
                stmt.setInt(1, projectId);
                stmt.executeUpdate();

                // Delete the project from running_projects table
                String deleteFromRunningProjectsSql = "DELETE FROM running_projects WHERE project_id = ?";
                stmt = conn.prepareStatement(deleteFromRunningProjectsSql);
                stmt.setInt(1, projectId);
                stmt.executeUpdate();
                
                out.println("<script type='text/javascript'>");
                out.println("window.alert('Project has been marked as completed successfully.');");
                
                out.println("</script>");
                

                response.sendRedirect("projects.html"); // Redirect back to the ongoing projects page

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
    }
}
