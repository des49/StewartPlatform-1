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

namespace StewartPlatformSerialController
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        List<string> availableComPorts = new List<string>();
        SerialPort serialConnection = new SerialPort();

        public MainWindow()
        {
            InitializeComponent();

            availableComPorts = new List<string>(SerialPort.GetPortNames().ToList());
            ComboBoxSerialPorts.ItemsSource = availableComPorts;
        }

        private void SendButton_Click(object sender, RoutedEventArgs e)
        {

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
            }
            if(ComboBoxSerialPorts.SelectedIndex != -1)
            {
                if(serialConnection.PortName != availableComPorts[ComboBoxSerialPorts.SelectedIndex])
                {
                    serialConnection.BaudRate = 9600;
                    serialConnection.PortName = availableComPorts[ComboBoxSerialPorts.SelectedIndex];
                    serialConnection.Open();
                }
                else
                {
                    MessageBox.Show("That serial port is already open");
                }
            }
            else
            {
                MessageBox.Show("There is no selected COM port to connect to\n\ntry selecting one.");
            }
        }

        private void serialConnection_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            if (ComboBoxSerialPorts.SelectedIndex != -1)
                OpenSerialConnection();
        }
    }
}
