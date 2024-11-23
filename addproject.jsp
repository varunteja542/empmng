<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Project</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        h1 {
            text-align: center;
            color: #2c3e50;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 10px;
            font-weight: bold;
            color: #34495e;
        }

        input, textarea, button {
            margin-top: 5px;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        textarea {
            resize: none;
        }

        button {
            margin-top: 20px;
            background-color: #1abc9c;
            color: white;
            cursor: pointer;
            border: none;
        }

        button:hover {
            background-color: #16a085;
        }

        .success, .error {
            text-align: center;
            margin-top: 20px;
            padding: 10px;
            border-radius: 5px;
            color: white;
        }

        .success {
            background-color: #2ecc71;
        }

        .error {
            background-color: #e74c3c;
        }

        .employee-list {
            margin-top: 10px;
        }

        .employee-list label {
            display: block;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add New Project</h1>

        <%
            String message = "";
            List<String[]> employees = new ArrayList<>();
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/emp", "root", "12345vt6");

                // Fetch employees for the checkbox
                String fetchEmployeesQuery = "SELECT emp_id, name FROM empp";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(fetchEmployeesQuery);

                while (rs.next()) {
                    employees.add(new String[]{String.valueOf(rs.getInt("emp_id")), rs.getString("name")});
                }

                rs.close();
                stmt.close();

                if (request.getMethod().equalsIgnoreCase("POST")) {
                    String projectId = request.getParameter("projectId");
                    String projectName = request.getParameter("projectName");
                    String projectDescription = request.getParameter("projectDescription");
                    String projectStatus = request.getParameter("projectStatus");
                    String[] selectedEmployees = request.getParameterValues("employees");

                    if (projectName != null && !projectName.trim().isEmpty() && projectId != null) {
                        // Insert project into 'projects' table
                        String insertProjectQuery = "INSERT INTO projects (project_id, project_name, project_description, project_status) VALUES (?, ?, ?, ?)";
                        PreparedStatement pstmt = conn.prepareStatement(insertProjectQuery);

                        pstmt.setInt(1, Integer.parseInt(projectId));
                        pstmt.setString(2, projectName);
                        pstmt.setString(3, projectDescription);
                        pstmt.setString(4, projectStatus);

                        int rows = pstmt.executeUpdate();

                        if (rows > 0) {
                            if (selectedEmployees != null) {
                                // Insert selected employees into 'project_emp' table
                                String insertProjectEmpQuery = "INSERT INTO project_emp (project_id, emp_id) VALUES (?, ?)";
                                PreparedStatement empPstmt = conn.prepareStatement(insertProjectEmpQuery);

                                for (String empId : selectedEmployees) {
                                    empPstmt.setInt(1, Integer.parseInt(projectId));
                                    empPstmt.setInt(2, Integer.parseInt(empId));
                                    empPstmt.addBatch();
                                }
                                empPstmt.executeBatch();
                                empPstmt.close();
                            }
                            message = "<div class='success'>Project and employees added successfully!</div>";
                        } else {
                            message = "<div class='error'>Failed to add project. Please try again.</div>";
                        }

                        pstmt.close();
                    } else {
                        message = "<div class='error'>Project name and ID are required.</div>";
                    }
                }

                conn.close();
            } catch (Exception e) {
                message = "<div class='error'>Error: " + e.getMessage() + "</div>";
            }
        %>

        <%= message %>

        <form method="POST">
            <label for="projectId">Project ID:</label>
            <input type="number" id="projectId" name="projectId" placeholder="Enter project ID" required>

            <label for="projectName">Project Name:</label>
            <input type="text" id="projectName" name="projectName" placeholder="Enter project name" required>

            <label for="projectDescription">Project Description:</label>
            <textarea id="projectDescription" name="projectDescription" rows="5" placeholder="Enter project description"></textarea>

            <label for="projectStatus">Project Status:</label>
            <select id="projectStatus" name="projectStatus">
                <option value="ongoing">Ongoing</option>
                <option value="completed">Completed</option>
            </select>

            <label for="employees">Select Employees:</label>
            <div class="employee-list">
                <% for (String[] emp : employees) { %>
                    <label>
                        <input type="checkbox" name="employees" value="<%= emp[0] %>">
                        <%= emp[0] %> - <%= emp[1] %>
                    </label>
                <% } %>
            </div>

            <button type="submit">Add Project</button>
        </form>
    </div>
</body>
</html>
