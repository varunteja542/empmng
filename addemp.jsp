<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Employee</title>
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

        input, select, button {
            margin-top: 5px;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
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

        .back-btn {
            background-color: #3498db;
        }

        .back-btn:hover {
            background-color: #2980b9;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>Add Employee</h1>

        <%
            String message = "";
            if (request.getMethod().equalsIgnoreCase("POST")) {
                try {
                    String empId = request.getParameter("emp_id");
                    String name = request.getParameter("name");
                    String position = request.getParameter("position");
                    String department = request.getParameter("department");
                    String password = request.getParameter("password");
                    String email = request.getParameter("email");
                    String birthDate = request.getParameter("birth_date");
                    String state = request.getParameter("state_province");
                    String zip = request.getParameter("zip_postal_code");
                    String country = request.getParameter("country");
                    String preferredLanguage = request.getParameter("preferred_language");
                    String dateOfHired = request.getParameter("date_of_hired");

                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/emp", "root", "12345vt6");

                    String insertQuery = "INSERT INTO empp (emp_id, name, position, department, password, email, birth_date, state_province, zip_postal_code, country, preferred_language, date_of_hired) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    PreparedStatement pstmt = conn.prepareStatement(insertQuery);
                    pstmt.setInt(1, Integer.parseInt(empId));
                    pstmt.setString(2, name);
                    pstmt.setString(3, position);
                    pstmt.setString(4, department);
                    pstmt.setString(5, password);
                    pstmt.setString(6, email);
                    pstmt.setDate(7, (birthDate != null && !birthDate.isEmpty()) ? java.sql.Date.valueOf(birthDate) : null);
                    pstmt.setString(8, state);
                    pstmt.setString(9, zip);
                    pstmt.setString(10, country);
                    pstmt.setString(11, preferredLanguage);
                    pstmt.setDate(12, (dateOfHired != null && !dateOfHired.isEmpty()) ? java.sql.Date.valueOf(dateOfHired) : null);

                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        message = "<div class='success'>Employee added successfully!</div>";
                    } else {
                        message = "<div class='error'>Failed to add employee. Please try again.</div>";
                    }

                    pstmt.close();
                    conn.close();
                } catch (SQLException e) {
                    message = "<div class='error'>SQL Error: " + e.getMessage() + "</div>";
                } catch (Exception e) {
                    message = "<div class='error'>Error: " + e.getMessage() + "</div>";
                }
            }
        %>

        <%= message %>
        <button type="button" class="back-btn" onclick="window.location.href='employee.jsp';">Back</button>
        <form method="POST">
            <label for="emp_id">Employee ID:</label>
            <input type="text" id="emp_id" name="emp_id" placeholder="Enter Employee ID" required>

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" placeholder="Enter Name" required>

            <label for="position">Position:</label>
            <input type="text" id="position" name="position" placeholder="Enter Position">

            <label for="department">Department:</label>
            <input type="text" id="department" name="department" placeholder="Enter Department">

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter Password">

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter Email">

            <label for="birth_date">Birth Date:</label>
            <input type="date" id="birth_date" name="birth_date">

            <label for="state_province">State/Province:</label>
            <input type="text" id="state_province" name="state_province" placeholder="Enter State/Province">

            <label for="zip_postal_code">ZIP/Postal Code:</label>
            <input type="text" id="zip_postal_code" name="zip_postal_code" placeholder="Enter ZIP/Postal Code">

            <label for="country">Country:</label>
            <input type="text" id="country" name="country" placeholder="Enter Country">

            <label for="preferred_language">Preferred Language:</label>
            <input type="text" id="preferred_language" name="preferred_language" placeholder="Enter Preferred Language">

            <label for="date_of_hired">Date of Hired:</label>
            <input type="date" id="date_of_hired" name="date_of_hired">

            <button type="submit">Add Employee</button>
            
        </form>
    </div>
</body>
</html>
