import java.io.*;
import java.sql.*;
import java.util.Base64;
import javax.servlet.*;
import javax.servlet.http.*;

public class empprof extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/emp";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345vt6";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); 
        Integer empId = (session != null) ? (Integer) session.getAttribute("emp_id") : null;

        if (empId == null) {
            response.setContentType("text/html");
            response.getWriter().println("<h3>Session expired or unauthorized access. Please log in again.</h3>");
            response.sendRedirect("login.html");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT name, position, department, profile_pic, birth_date, state_province, zip_postal_code, country, preferred_language FROM empp WHERE emp_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, empId);

            rs = stmt.executeQuery();

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            if (rs.next()) {
                String name = rs.getString("name");
                String position = rs.getString("position");
                String department = rs.getString("department");
                String birthDate = rs.getString("birth_date");
                String stateProvince = rs.getString("state_province");
                String zipPostalCode = rs.getString("zip_postal_code");
                String country = rs.getString("country");
                String preferredLanguage = rs.getString("preferred_language");

                byte[] profilePicBytes = rs.getBytes("profile_pic");
                String profilePicBase64 = profilePicBytes != null
                        ? Base64.getEncoder().encodeToString(profilePicBytes)
                        : "default_profile_pic_base64_string";

                // HTML Output for Profile
                out.println("<html>");
                out.println("<head>");
                out.println("<style>");
                out.println("body { font-family: Arial, sans-serif; background-color: #f4f4f9; margin: 0; padding: 0; }");
                out.println(".container { width: 80%; margin: 0 auto; padding-top: 20px; }");
                out.println(".profile-card { background-color: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); padding: 20px; max-width: 800px; margin: 0 auto; text-align: center; }");
                out.println(".profile-card img { width: 150px; height: 150px; border-radius: 50%; border: 3px solid #ddd; }");
                out.println(".profile-card h2 { font-size: 2em; color: #333; margin: 20px 0; }");
                out.println(".profile-card p { font-size: 1.1em; color: #555; margin: 10px 0; }");
                out.println(".profile-card .info { font-size: 1.1em; color: #333; text-align: left; padding-left: 20px; margin-top: 20px; }");
                out.println(".profile-card .info p { margin-bottom: 8px; }");
                out.println("</style>");
                out.println("</head>");
                out.println("<body>");

                out.println("<div class=\"container\">");
                out.println("<div class=\"profile-card\">");
                out.println("<img src=\"data:image/jpeg;base64," + profilePicBase64 + "\" alt=\"Profile Picture\">");
                out.println("<h2>" + name + "</h2>");
                out.println("<p><strong>Employee ID:</strong> " + empId + "</p>");
                out.println("<p><strong>Position:</strong> " + position + "</p>");
                out.println("<p><strong>Department:</strong> " + department + "</p>");

                out.println("<div class=\"info\">");
                out.println("<p><strong>Birth Date:</strong> " + (birthDate != null ? birthDate : "Not Provided") + "</p>");
                out.println("<p><strong>State/Province:</strong> " + (stateProvince != null ? stateProvince : "Not Provided") + "</p>");
                out.println("<p><strong>ZIP/Postal Code:</strong> " + (zipPostalCode != null ? zipPostalCode : "Not Provided") + "</p>");
                out.println("<p><strong>Country:</strong> " + (country != null ? country : "Not Provided") + "</p>");
                out.println("<p><strong>Preferred Language:</strong> " + (preferredLanguage != null ? preferredLanguage : "Not Provided") + "</p>");
                out.println("</div>"); 

                out.println("</div>"); 
                out.println("</div>"); 
                out.println("</body>");
                out.println("</html>");

            } else {
                out.println("<h3>Profile not found. Please contact admin.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<h2>Error fetching profile data: " + e.getMessage() + "</h2>");
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
