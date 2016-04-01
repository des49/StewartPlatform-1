using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO.Ports;
using System.Windows.Threading;

namespace StewartPlatformSerialController
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        List<string> availableComPorts = new List<string>();
        SerialPort serialConnection = new SerialPort();
        string serialWindow = "";

        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = this;
            availableComPorts = new List<string>(SerialPort.GetPortNames().ToList());
            ComboBoxSerialPorts.ItemsSource = availableComPorts;

        }

        private void SendButton_Click(object sender, RoutedEventArgs e)
        {
            if (serialConnection.IsOpen)
                SendMessage();
            else
                MessageBox.Show("You need to connect first");
        }

        private void QuitButton_Click(object sender, RoutedEventArgs e)
        {
            if (serialConnection.IsOpen)
                serialConnection.Close();
            this.Close();
        }

        private void OpenSerialConnection()
        {
            if (serialConnection.IsOpen)
            {
                serialConnection.Close();
                ConnectButton.Background = Brushes.Red;
            }
            if (ComboBoxSerialPorts.SelectedIndex != -1)
            {
                serialConnection.DataReceived += serialConnection_DataReceived;
                serialConnection.BaudRate = 9600;
                serialConnection.PortName = availableComPorts[ComboBoxSerialPorts.SelectedIndex];
                serialConnection.Open();
                ConnectButton.Background = Brushes.LightGreen;
            }
            else
            {
                MessageBox.Show("There is no selected COM port to connect to\n\ntry selecting one.");
            }
        }

        private void serialConnection_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort sp = (SerialPort)sender;
            serialWindow += sp.ReadExisting();
            if (SerialMonitor.Dispatcher.CheckAccess())
            {
                // The calling thread owns the dispatcher, and hence the UI element
                SerialMonitor.Text = serialWindow;
            }
            else
            {
                // Invokation required
                SerialMonitor.Dispatcher.Invoke(updateText);
            }
        }

        public void updateText()
        {
            SerialMonitor.Text = serialWindow;
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            if (ComboBoxSerialPorts.SelectedIndex != -1)
                OpenSerialConnection();
            else
                MessageBox.Show("There is no selected port to connect to");
        }

        private void ComboBoxSerialPorts_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            availableComPorts = new List<string>(SerialPort.GetPortNames().ToList());
            ComboBoxSerialPorts.ItemsSource = availableComPorts;
        }

        private void TextBox_RollAngle_TextChanged(object sender, TextChangedEventArgs e)
        {
            if(this.IsLoaded)
                if(CheckBox_SendContinuously.IsChecked.HasValue)
                    if((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void TextBox_ZTranslation_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (this.IsLoaded)
                if (CheckBox_SendContinuously.IsChecked.HasValue)
                    if ((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void TextBox_YTranslation_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (this.IsLoaded)
                if (CheckBox_SendContinuously.IsChecked.HasValue)
                    if ((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void TextBox_XTranslation_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (this.IsLoaded)
                if (CheckBox_SendContinuously.IsChecked.HasValue)
                    if ((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void TextBox_YawAngle_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (this.IsLoaded)
                if (CheckBox_SendContinuously.IsChecked.HasValue)
                    if ((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void TextBox_PitchAngle_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (this.IsLoaded)
                if (CheckBox_SendContinuously.IsChecked.HasValue)
                    if ((bool)CheckBox_SendContinuously.IsChecked)
                        SendMessage();
        }

        private void Slider_RollAngle_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_RollAngle.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()), 3).ToString();
        }

        private void Slider_ZTranslation_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_ZTranslation.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()), 3).ToString();
        }

        private void Slider_YTranslation_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_YTranslation.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()), 3).ToString();
        }

        private void Slider_XTranslation_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_XTranslation.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()),3).ToString();
        }

        private void Slider_YawAngle_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_YawAngle.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()), 3).ToString();
        }

        private void Slider_PitchAngle_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            TextBox_PitchAngle.Text = Math.Round(Convert.ToSingle(e.NewValue.ToString()), 3).ToString();
        }

        private void CheckBox_SendContinuously_Checked(object sender, RoutedEventArgs e)
        {
            if (!serialConnection.IsOpen)
            {
                MessageBox.Show("Can't send messages until you connect to a serial port");
                (e.Source as CheckBox).IsChecked = false;
            }
            else
                SendMessage();
        }   

        private void SendMessage()
        {
            if (serialConnection.IsOpen && serialConnection.BytesToWrite == 0)
            {
                //maybe something like this...?
                byte[] message = new byte[24];
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_RollAngle.Text)), 0, message, 0, 4);
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_PitchAngle.Text)), 0, message, 4, 4);
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_YawAngle.Text)), 0, message, 8, 4);
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_XTranslation.Text)), 0, message, 12, 4);
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_YTranslation.Text)), 0, message, 16, 4);
                Buffer.BlockCopy(BitConverter.GetBytes(Convert.ToSingle(TextBox_ZTranslation.Text)), 0, message, 20, 4);
                serialConnection.Write(message,0,24);
            }
        }
    }
}
