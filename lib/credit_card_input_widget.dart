part of credit_card_input;

class CreditCardForm extends StatefulWidget {
  final String? cardNumberLabel;
  final String? cardHolderLabel;
  final bool? hideCardHolder;
  final String? expiredDateLabel;
  final String? cvcLabel;
  final Widget? cvcIcon;
  final int? cardNumberLength;
  final int? cvcLength;
  final double fontSize;
  final CreditCardTheme? theme;
  final Function(CardData) onChanged;
  final Function? onDone;
  final CardDataInputController controller;
  const CreditCardForm({
    super.key,
    this.theme,
    required this.onChanged,
    this.onDone,
    this.cardNumberLabel,
    this.cardHolderLabel,
    this.hideCardHolder = false,
    this.expiredDateLabel,
    this.cvcLabel,
    this.cvcIcon,
    this.cardNumberLength = 16,
    this.cvcLength = 4,
    this.fontSize = 16,
    required this.controller,
  });

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  // card image
  CardImage cardImage = const CardImage();

  // card type
  CardType? cardType;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.cardNumber.addListener(() {
      setState(() {
        cardImage = CardUtils.getCardIcon(widget.controller.cardNumber.text);
        cardType = widget.controller.value.cardType;
        emitResult();
      });
    });
    widget.controller.cardHolderName.addListener(() {
      emitResult();
    });
    widget.controller.expiredDate.addListener(() {
      emitResult();
    });
    widget.controller.cvc.addListener(() {
      emitResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    CreditCardTheme theme = widget.theme ?? CreditCardLightTheme();
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border.all(color: theme.borderColor, width: 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(children: [
        // [card number]
        TextInputWidget(
          theme: theme,
          fontSize: widget.fontSize,
          controller: widget.controller.cardNumber,
          label: widget.cardNumberLabel ?? 'Card number',
          textInputAction: TextInputAction.next,
          bottom: 1,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.cardNumberLength),
            CardNumberInputFormatter(),
          ],
          onChanged: noop,
        ),
        // [card holder name]
        if (widget.hideCardHolder == false)
          TextInputWidget(
            theme: theme,
            fontSize: widget.fontSize,
            label: widget.cardHolderLabel ?? 'Card holder name',
            controller: widget.controller.cardHolderName,
            textInputAction: TextInputAction.next,
            bottom: 1,
            onChanged: noop,
            keyboardType: TextInputType.name,
          ),
        // [expired date]
        Row(
          children: [
            Expanded(
              child: TextInputWidget(
                theme: theme,
                fontSize: widget.fontSize,
                label: widget.expiredDateLabel ?? 'MM/YY',
                textInputAction: TextInputAction.next,
                right: 1,
                onChanged: noop,
                controller: widget.controller.expiredDate,
                formatters: [
                  CardExpirationFormatter(),
                  LengthLimitingTextInputFormatter(5)
                ],
              ),
            ),
            // [cvc]
            Expanded(
              child: TextInputWidget(
                theme: theme,
                fontSize: widget.fontSize,
                label: widget.cvcLabel ?? 'CVC',
                controller: widget.controller.cvc,
                textInputAction: TextInputAction.done,
                password: true,
                onChanged: noop,
                onDone: () {
                  widget.onDone?.call();
                },
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.cvcLength)
                ],
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget.cvcIcon ??
                      Image.asset(
                        'images/cvc.png',
                        package: 'credit_card_input',
                        height: 25,
                      ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  emitResult() {
    widget.onChanged(widget.controller.value);
  }
}
