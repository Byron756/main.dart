import 'package:flutter/material.dart';

void main() {
  runApp(SendMoneyApp());
}

class SendMoneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SendMoneyScreen(),
    );
  }
}

class SendMoneyScreen extends StatefulWidget {
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Bank Transfer';
  bool _isFavorite = false;
  bool _showSuccess = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Recipient Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      final amount = double.tryParse(value ?? '');
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid positive amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedMethod,
                    items: ['Bank Transfer', 'Mobile Money', 'PayPal']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Payment Method'),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mark as Favorite'),
                      Switch(
                        value: _isFavorite,
                        onChanged: (value) {
                          setState(() {
                            _isFavorite = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SendButton(onPressed: _submitForm),
                ],
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showSuccess ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Text(
                'Transaction Successful!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SendButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        backgroundColor: Colors.blue,
      ),
      child: Text('Send Money'),
    );
  }
}
