import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class FetchProjects extends HttpServlet {
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h1>erroe</h1>");

          
     }
}
    