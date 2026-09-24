import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserRegistrationForm(),
    );
  }
}

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      debugPrint('Form Data: ${_formKey.currentState!.value}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Validation Failed')),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  void _fillSampleData() {
    _formKey.currentState!.patchValue({
      "full_name": "John Doe",
      "email": "johndoe@example.com",
      "gender": "Male",
      "dob": DateTime(1990),
      "marital_status": "Single",
      "accept_terms": true,
      "satisfaction": 5.0,
      "notification": true,
      "age_range": const RangeValues(18, 30),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Registration Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderRangeSlider(
                  name: "age_range",
                  min: 18,
                  max: 100,
                  initialValue: const RangeValues(18, 100),
                  divisions: 10,
                  decoration: const InputDecoration(labelText: "Age Range"),
                ),
                const SizedBox(height: 15),
                FormBuilderDateRangePicker(
                  name: "dob",
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  decoration: const InputDecoration(
                    labelText: "Date of Birth",
                  ),
                ),
                FormBuilderFilterChips(
                  name: "hobbies",
                  options: const [
                    FormBuilderChipOption(value: "Reading"),
                    FormBuilderChipOption(value: "Writing"),
                    FormBuilderChipOption(value: "Travelling"),
                  ],
                  decoration: const InputDecoration(labelText: "Hobbies"),
                ),
                FormBuilderTextField(
                  name: "full_name",
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                  ]),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: "email",
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 15),
                FormBuilderDropdown(
                  name: "gender",
                  decoration: const InputDecoration(labelText: "Gender"),
                  items: ["Male", "Female", "Other"]
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 15),
                FormBuilderDateTimePicker(
                  name: "dob",
                  inputType: InputType.date,
                  decoration: const InputDecoration(labelText: "Date of Birth"),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 15),
                FormBuilderRadioGroup(
                  name: "marital_status",
                  decoration:
                      const InputDecoration(labelText: "Marital Status"),
                  options: ["Single", "Married", "Divorced"]
                      .map((status) => FormBuilderFieldOption(value: status))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 15),
                FormBuilderCheckbox(
                  name: "accept_terms",
                  initialValue: false,
                  title: const Text("I accept the terms and conditions"),
                  validator: FormBuilderValidators.equal(true,
                      errorText: "You must accept the terms"),
                ),
                const SizedBox(height: 15),
                FormBuilderSlider(
                  name: "satisfaction",
                  min: 0,
                  max: 10,
                  initialValue: 5,
                  divisions: 10,
                  decoration:
                      const InputDecoration(labelText: "Satisfaction Level"),
                ),
                const SizedBox(height: 15),
                FormBuilderSwitch(
                  name: "notifications",
                  title: const Text("Enable Notifications"),
                  initialValue: true,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Submit"),
                    ),
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: const Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _fillSampleData,
                      child: const Text("Fill Sample Data"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
