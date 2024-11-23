<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Ongoing Projects</title>
    <style>
        /* Add your existing styles here */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            flex-direction: row;
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            min-height: 100vh;
            padding-top: 20px;
        }

        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }

        .sidebar ul li {
            padding: 15px;
            cursor: pointer;
            border-bottom: 1px solid #34495e;
            text-align: center;
        }

        .sidebar ul li:hover {
            background-color: #1abc9c;
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            display: block;
        }

        .main-content {
            flex: 1;
            padding: 20px;
        }

        .btn {
            background-color: #1abc9c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #16a085;
        }

        .project-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .project-table th, .project-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .project-table th {
            background-color: #f2f2f2;
        }

        .update-button {
            background-color: #f39c12;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .update-button:hover {
            background-color: #e67e22;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2 style="text-align: center;">Menu</h2>
            <ul>
                <li><a href="admindashboard.jsp">Projects(ongoing)</a></li>
                <li><a href="totalpp.jsp">Completed Projects</a></li>
                <li><a href="employee.jsp">Employees</a></li>
                <li><a href="addproject.jsp">Add Project</a></li>
                <li><a href="adminlogin.html">Logout</a></li>
            </ul>
        </div>

        <div class="main-content">
            <h1>Ongoing Projects</h1>
            <a href="addproject.jsp" class="btn">Add Project</a>
            <table class="project-table">
                <tr>
                    <th>Project ID</th>
                    <th>Project Name</th>
                    <th>Project Description</th>
                    <th>Employees (ID - Name)</th>
                </tr>
                <%
                    // Database connection details
                    String url = "jdbc:mysql://localhost:3306/emp";
                    String user = "root";
                    String password = "12345vt6";

                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, user, password);


                        String sql = "SELECT p.project_id, p.project_name, p.project_description, "
                                   + "GROUP_CONCAT(CONCAT(e.emp_id, ' - ', e.name) SEPARATOR '<br>') AS employees "
                                   + "FROM running_projects rp "
                                   + "JOIN projects p ON rp.project_id = p.project_id "
                                   + "LEFT JOIN project_emp pe ON p.project_id = pe.project_id "
                                   + "LEFT JOIN empp e ON pe.emp_id = e.emp_id "
                                   + "GROUP BY p.project_id";

                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("project_id") %></td>
                    <td><%= rs.getString("project_name") %></td>
                    <td><%= rs.getString("project_description") %></td>
                    <td><%= rs.getString("employees") != null ? rs.getString("employees") : "No employees assigned" %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (ps != null) try { ps.close(); } catch (SQLException e) {}
                        if (conn != null) try { conn.close(); } catch (SQLException e) {}
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>
