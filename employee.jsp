<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        
        .container {
            display: flex;
        }

        /* Sidebar Styling */
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
            margin-left: 250px; /* Adjust the margin to give space for the sidebar */
        }

        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f4f4f4;
        }

        .btn {
            background-color: #1abc9c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            margin: 20px;
        }

        .btn:hover {
            background-color: #16a085;
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
                <li><a href="addemp.jsp">Add Employee</a></li>
                <li><a href="adminlogin.html">Logout</a></li>
            </ul>
        </div>

        <div class="main-content">
            <h2 style="text-align: center;">Employee Details</h2>
            <table>
                <tr>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Position</th>
                    <th>Department</th>
                    <th>Email</th>
                    <th>Birth Date</th>
                    <th>State</th>
                    <th>Zip Code</th>
                    <th>Country</th>
                    <th>Preferred Language</th>
                    <th>Date of Hired</th>
                </tr>
                <%
                    // Database connection details
                    String url = "jdbc:mysql://localhost:3306/emp";
                    String username = "root";
                    String password = "12345vt6";

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, username, password);
                        stmt = conn.createStatement();
                        String query = "SELECT emp_id, name, position, department, email, birth_date, state_province, " +
                                       "zip_postal_code, country, preferred_language, date_of_hired FROM empp";
                        rs = stmt.executeQuery(query);

                        // Display data in table rows
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("emp_id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("position") %></td>
                    <td><%= rs.getString("department") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getDate("birth_date") %></td>
                    <td><%= rs.getString("state_province") %></td>
                    <td><%= rs.getString("zip_postal_code") %></td>
                    <td><%= rs.getString("country") %></td>
                    <td><%= rs.getString("preferred_language") %></td>
                    <td><%= rs.getDate("date_of_hired") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="11" style="color: red; text-align: center;">Error fetching data!</td>
                </tr>
                <%
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </table>

            
            <a href="addemp.jsp" class="btn">Add Employee</a>
        </div>
    </div>
</body>
</html>
