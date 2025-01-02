import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              'Frequently Asked Questions',
              [
                _buildFAQTile(
                  'How do I book an appointment?',
                  'To book an appointment, go to the home screen and tap "Book Appointment". Select your preferred doctor, date, and time.',
                ),
                _buildFAQTile(
                  'How can I cancel my appointment?',
                  'Go to "My Appointments" and select the appointment you want to cancel. Tap the cancel button and confirm.',
                ),
                _buildFAQTile(
                  'How do I update my profile?',
                  'Navigate to Profile > Personal Details to update your information.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              'Contact Support',
              [
                _buildContactTile(
                  'Email Support',
                  'support@example.com',
                  Icons.email,
                  () {/* Launch email */},
                ),
                _buildContactTile(
                  'Phone Support',
                  '+1 (555) 123-4567',
                  Icons.phone,
                  () {/* Launch phone */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
