# Volunteer Management System

## Overview

The Volunteer Management System is designed to streamline the process of managing volunteer activities within an organization. It provides a platform for volunteers to engage with upcoming events, register their participation, track their contributions, and receive recognition for their efforts. For administrators, it offers tools to manage activities, volunteers, and generate reports that highlight volunteer engagement and impact.

## Getting Started with Opening the Flutter Project

This section provides a step-by-step guide on how to set up and open the Flutter project for the Volunteer Management System. Whether you're a developer looking to contribute or an admin wanting to customize the system, these instructions will help you get started.

### Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK**: Download and install Flutter from the [official website](https://flutter.dev/docs/get-started/install).
- **Dart SDK**: Included with Flutter.
- **An IDE with Flutter support**: Android Studio, VS Code, or IntelliJ IDEA are recommended.

### Setting Up the Development Environment

1. **Clone the Repository**: Start by cloning the project repository to your local machine using Git [`git clone [https://example.com/vms.git](https://github.com/ruth-lim/hackforgood24.git)`.
2. **Navigate to the Project Directory**: Change into the project directory from your terminal. [`cd hackforgood24`]
3. **Get Flutter Dependencies**: Run the following command `flutter pub get` to fetch all the required Flutter packages for the project.
4. **Open the Project in Your IDE**: Launch your preferred IDE and open the project folder you've just cloned.

### Running the Project

1. **Choose a Target Device**: Ensure you have an emulator running or a physical device connected to your computer.
2. **Run the App**: Execute the following command `flutter run` in your terminal or use the run button in your IDE.

### Troubleshooting

- If you encounter any issues with package versions or compatibility, consider running `flutter doctor` to diagnose common problems or refer to the Flutter documentation for troubleshooting tips.

## System Features

### Sign-Up Page

The Sign-Up page allows new users to create an account by providing necessary information across several fields. Here are the fields included in the sign-up process:

- **Email**: Users must provide a valid email address that will be used for account verification and communication purposes.
- **Password**: A strong password is required for account security. The password must meet our minimum security criteria (e.g., a minimum of 8 characters).
- **Confirm Password**: Users must re-enter their password to confirm accuracy.
- **Username**: A unique username for the user's profile. This name will be visible to other users of the application.
- **Phone Number**: Users are required to provide a phone number for account recovery and security verification.
- **Date of Birth**: To ensure compliance with age restrictions, users must provide their date of birth.
- **Gender**: Users have the option to specify their gender. This field is optional and can be left unspecified if desired.
- **Occupation & School**: For users who wish to share professional or educational information, these fields allow for the input of occupation details and school name.
- **Educational Background**: Users can select their highest level of education from a dropdown menu.
- **Availability**: Users can specify their availability for participation in events or activities.
- **Driving Status & Vehicle Ownership**: These fields are specifically designed for applications requiring information about the user's ability to drive and vehicle ownership status.
- **Skills & Interests**: Users can list their skills and interests to better match with relevant activities or groups within the app.
- **Commitment Level**: Users can indicate whether they are looking for ad-hoc participation opportunities or are interested in regular commitments.
- **Immigration Status**: This field allows users to select their immigration status from a predefined list of options.

### Login Page

The Login page provides a straightforward mechanism for users to access their accounts:

- **Email**: Users enter their registered email address.
- **Password**: Users enter their password.

Login credentials are verified against our secure backend to grant access. Users also have the option to reset their password if forgotten.

### Security Measures

Our application employs state-of-the-art security practices to protect user information and privacy. Passwords are encrypted, and data transmission is secured using SSL encryption. Additionally, our authentication system integrates with Firebase Authentication, providing reliable and scalable user management.

### Volunteer Interface

#### Dashboard

- **Upcoming Activities**: Displays a list of upcoming volunteer events. Volunteers can view details and register their interest.
- **Activities Already Enrolled In**: Shows the events a volunteer is already registered for, including dates and other pertinent details.

#### Activities Page

- **Event Registration**: Features buttons to register for specific events.
- **Event Details**: Displays time, location, special skills required, and the current number of enrolled volunteers.
- **Post-Event Satisfaction Form**: After event participation, volunteers are prompted to fill out a satisfaction survey.

#### Request Certificate Page

- Allows volunteers to request an unofficial transcript/certificate detailing their name, hours volunteered, events participated in, and the organization's signature.

#### Profile and Settings

The Profile Editing page enables users to update various details and preferences associated with their account. Here are the features available in the profile editing section:

- **Profile Picture**: Users can upload or change their profile picture by selecting an image from their device's gallery.
- **Username**: Users can modify their displayed username.
- **Email Address**: This field allows users to update their registered email address. Changes to the email address require re-verification for security purposes.
- **Phone Number**: Users can update their phone number associated with the account.
- **Date of Birth**: Allows users to change their date of birth if necessary.
- **Gender**: Users have the option to specify or update their gender.
- **Occupation & School**: Fields for users to update their occupation details and school name.
- **Educational Background**: Users can select their current or highest level of education from a dropdown menu.
- **Availability**: Users can specify their availability for participation in events or activities.
- **Driving Status & Vehicle Ownership**: Allows users to update information about their driving status and vehicle ownership.
- **Skills & Interests**: Users can add or remove skills and interests to better match with relevant activities or groups within the app.
- **Commitment Level**: Users can update their preference for ad-hoc or regular participation opportunities.
- **Immigration Status**: Allows users to update their immigration status from a predefined list of options.

### Saving Changes

Once users have made the desired updates to their profile, they can save the changes using the "Save Changes" button. Upon clicking this button, the modified information is sent to the server and updated in the database.

### Admin Interface

#### Dashboard

- **Metrics**: Displays total number of volunteers, total number of events, and other key metrics.

#### Activity Management

- **Event Creation**: An interface to add new volunteer events, including title, location, date, time, and the number of volunteers needed.
- **Volunteer Spreadsheet**: Manages the list of volunteers signed up for each event.
- **Volunteer Attendance**: Allows admins to track volunteers' attendance for events manually.

#### Certificate Page

- **Template Upload**: Admins can upload a certificate template with placeholders for the volunteer’s name, activities completed, and date.

#### Reports Page

The Reports Page in the Volunteer Management System (VMS) serves as a vital analytics and reporting hub, designed to provide administrators and program managers with in-depth insights into volunteer engagement, program outcomes, and organizational impact. Below is a detailed overview of the reports available:

1. Volunteer Enrollment and Demographics Report
Overview: Offers comprehensive data on volunteer demographics, including age, gender, location, and occupation.
Purpose: Facilitates targeted recruitment and helps understand the volunteer base for better engagement strategies.
2. Activity Participation Report
Overview: Details volunteer participation across various activities, highlighting the number of participants, hours contributed, and activity types.
Purpose: Provides insights into the popularity and engagement levels of different volunteer activities.
3. Attendance and Time Tracking Report
Overview: Tracks volunteer attendance at events and activities, including detailed hours volunteered by each participant.
Purpose: Ensures accurate recording of volunteer contributions and supports program accountability.
4. Certificate Request Report
Overview: Lists all certificate requests by volunteers, including the type of certificate, request date, and relevant activity.
Purpose: Streamlines the process of recognizing volunteer efforts through certificates.
5. Feedback and Evaluation Report
Overview: Collects and summarizes volunteer feedback on their experience, pinpointing areas of satisfaction and suggestions for improvement.
Purpose: Informs program improvements and strategies to enhance volunteer satisfaction and retention.
6. Impact and Outcomes Report
Overview: Assesses the impact of volunteer activities on the community, detailing metrics such as people served and resources deployed.
Purpose: Demonstrates the tangible outcomes and effectiveness of volunteer efforts.
7. Financial Report
Overview: Provides a breakdown of expenses related to volunteer activities, including materials, venue rentals, and other costs.
Purpose: Aids in financial planning and budgeting for volunteer-related expenses.
8. Performance and Efficiency Report
Overview: Evaluates program performance and efficiency, using metrics such as volunteer retention rate and cost per volunteer hour.
Purpose: Highlights opportunities for operational improvements and efficiency gains.
9. Volunteer Recognition and Awards Report
Overview: Features volunteers who have shown exceptional dedication or impact, recognizing their contributions to the organization.
Purpose: Promotes a culture of appreciation and motivates volunteers through recognition.
10. Trends and Patterns Analysis Report
Overview: Analyzes long-term trends in volunteer participation, identifying popular activities, seasonal variations, and emerging preferences.
Purpose: Guides strategic planning and program development with insights into volunteer engagement patterns.

##### Accessing and Utilizing Reports
Navigation: These reports can be accessed through the dedicated Reports Page on the admin dashboard.
Customization: Users have the ability to customize reports based on specific criteria such as date ranges, activities, and demographics.
Export: For further analysis or presentation purposes, reports can be exported in various formats.

## Getting Started

### For Volunteers

1. **Registration**: Begin by registering an account and filling in your profile with personal information, skills, and interests.
2. **Dashboard Navigation**: Use the dashboard to find and sign up for upcoming volunteer activities.
3. **Participation and Feedback**: After attending events, submit your hours and feedback through the system.

### For Admins

1. **Activity Setup**: Create and manage volunteer events through the Activity Management interface.
2. **Volunteer Management**: Keep track of volunteer sign-ups, attendance, and post-event feedback.
3. **Reporting**: Generate reports to analyze volunteer engagement, event impact, and overall program success.

Future Plans for Volunteer Management System
As we continue to develop and improve the Volunteer Management System (VMS), we are excited about the roadmap ahead. Our commitment to enhancing volunteer engagement and organizational efficiency guides our future plans, which include:

**User Experience Enhancements**
- Intuitive Mobile Design: Redesign the mobile experience for optimal usability and engagement.
- Dashboard Personalization: Implement AI to offer personalized volunteer opportunities and insights.

**Analytics and Reporting**
- Impact Metrics: Introduce tools for organizations to measure and report the impact of their volunteer activities.
- Custom Reports: Enable customizable reporting features for more detailed insights.

**Integration and Interoperability**
- Open API: Develop and release an API for integrating VMS with existing CRM systems, social media platforms, and other relevant tools.
- Strategic Partnerships: Forge partnerships with key platforms and organizations to broaden volunteer opportunities and streamline processes.

**Community and Engagement**
- Social Features: Build a community platform within VMS for volunteers to connect, share, and collaborate.
- Recognition and Rewards: Enhance recognition programs with digital badges, achievements, and leaderboards.

**Security and Compliance**
- Enhanced Data Protection: Strengthen security measures and encryption to protect user data.
- Regulatory Compliance: Ensure ongoing compliance with global data protection and privacy regulations.

**Accessibility and Inclusion**
- Multi-language Support: Expand language options to cater to a global user base.
- Accessibility Features: Improve accessibility for users with disabilities, ensuring everyone can participate fully.

**Feedback and Iteration**
- User Feedback Loops: Establish mechanisms for regular user feedback to continually refine and improve VMS.

