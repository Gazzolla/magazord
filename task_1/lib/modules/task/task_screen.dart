import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:task_1/shared/constants.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formGroup = FormGroup({
      "title": FormControl(validators: [Validators.required]),
      "description": FormControl(),
      "category": FormControl<String>(validators: [Validators.required]),
    });

    return Padding(
      padding: EdgeInsets.all(25),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xfff4f4f4),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ReactiveForm(
              formGroup: formGroup,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50),
                            Text(
                              "Nome da Atividade",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            ReactiveTextField(
                              formControlName: "title",
                              keyboardType: TextInputType.text,
                              onSubmitted: (control) {
                                formGroup.control('description').focus();
                              },
                              textInputAction: TextInputAction.next,
                              validationMessages: validationMessages,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Descrição da Atividade",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              height: 40,
                              child: ReactiveTextField(
                                formControlName: "description",
                                keyboardType: TextInputType.multiline,
                                onSubmitted: (control) {
                                  FocusScope.of(context).unfocus();
                                },
                                minLines: 1,
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                validationMessages: validationMessages,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Categoria da Atividade",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              height: 40,
                              child: ReactiveDropdownField(
                                items: [
                                  DropdownMenuItem(value: "Casa", child: Text('Casa')),
                                  DropdownMenuItem(value: "Trabalho", child: Text('Trabalho')),
                                  DropdownMenuItem(value: "Lazer", child: Text('Lazer')),
                                  DropdownMenuItem(value: "Saúde", child: Text('Saúde')),
                                  DropdownMenuItem(value: "Financeiro", child: Text('Financeiro')),
                                  DropdownMenuItem(value: "Pessoal", child: Text('Casa')),
                                  DropdownMenuItem(value: "Carro", child: Text('Carro')),
                                ],
                                formControlName: "category",
                                validationMessages: validationMessages,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.grey),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)))),
                        onPressed: () {
                          formGroup.controls.forEach((key, value) => value.markAsTouched());
                          if (formGroup.valid) {
                            Navigator.pop(context, formGroup.rawValue);
                          }
                        },
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
