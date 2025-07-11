"""
The Immigrants Game - Event Management Backend
A Python Qt application for managing game events in Firebase
"""

import sys
import json
import os
from typing import Dict, List, Optional, Any
import logging
from datetime import datetime

# Qt imports
from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, 
    QTableWidget, QTableWidgetItem, QPushButton, QLineEdit, QTextEdit,
    QLabel, QComboBox, QSpinBox, QDoubleSpinBox, QCheckBox, QTabWidget,
    QMessageBox, QDialog, QFormLayout, QDialogButtonBox, QGroupBox,
    QScrollArea, QSplitter, QFrame, QProgressBar, QStatusBar
)
from PyQt6.QtCore import Qt, QThread, pyqtSignal, QTimer, QSettings
from PyQt6.QtGui import QFont, QIcon, QPixmap, QAction

# Firebase imports
try:
    import firebase_admin
    from firebase_admin import credentials, firestore
    FIREBASE_AVAILABLE = True
except ImportError:
    FIREBASE_AVAILABLE = False
    print("Firebase admin SDK not available. Install with: pip install firebase-admin")

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FirebaseManager:
    """Manages Firebase connection and operations"""
    
    def __init__(self):
        self.db = None
        self.is_connected = False
        
    def connect(self, credentials_path: str) -> bool:
        """Connect to Firebase using service account credentials"""
        try:
            if not FIREBASE_AVAILABLE:
                logger.error("Firebase admin SDK not available")
                return False
                
            # Initialize Firebase
            cred = credentials.Certificate(credentials_path)
            firebase_admin.initialize_app(cred)
            self.db = firestore.client()
            self.is_connected = True
            logger.info("Successfully connected to Firebase")
            return True
            
        except Exception as e:
            logger.error(f"Failed to connect to Firebase: {e}")
            return False
    
    def get_all_events(self) -> List[Dict]:
        """Get all events from Firebase"""
        if not self.is_connected:
            return []
            
        try:
            events = []
            
            # Get territory events
            territory_doc = self.db.collection('events').document('territory_events').get()
            if territory_doc.exists:
                territory_data = territory_doc.to_dict()
                for territory_type, territory_events in territory_data.items():
                    for event in territory_events:
                        event['territoryType'] = territory_type
                        events.append(event)
            
            # Get milestone events
            milestone_doc = self.db.collection('events').document('milestone_events').get()
            if milestone_doc.exists:
                milestone_data = milestone_doc.to_dict()
                if 'milestones' in milestone_data:
                    for event in milestone_data['milestones']:
                        event['territoryType'] = 'milestone'
                        events.append(event)
            
            return events
            
        except Exception as e:
            logger.error(f"Error getting events: {e}")
            return []
    
    def add_event(self, event: Dict, territory_type: str) -> bool:
        """Add a new event to Firebase"""
        if not self.is_connected:
            return False
            
        try:
            if territory_type == 'milestone':
                # Add to milestone events
                milestone_doc = self.db.collection('events').document('milestone_events')
                milestone_data = milestone_doc.get().to_dict() or {'milestones': []}
                milestone_data['milestones'].append(event)
                milestone_doc.set(milestone_data)
            else:
                # Add to territory events
                territory_doc = self.db.collection('events').document('territory_events')
                territory_data = territory_doc.get().to_dict() or {}
                if territory_type not in territory_data:
                    territory_data[territory_type] = []
                territory_data[territory_type].append(event)
                territory_doc.set(territory_data)
            
            logger.info(f"Added event: {event.get('id', 'unknown')}")
            return True
            
        except Exception as e:
            logger.error(f"Error adding event: {e}")
            return False
    
    def update_event(self, event: Dict, territory_type: str) -> bool:
        """Update an existing event in Firebase"""
        if not self.is_connected:
            return False
            
        try:
            event_id = event.get('id')
            if not event_id:
                return False
                
            # Remove old event and add updated one
            if self.delete_event(event_id, territory_type):
                return self.add_event(event, territory_type)
            
            return False
            
        except Exception as e:
            logger.error(f"Error updating event: {e}")
            return False
    
    def delete_event(self, event_id: str, territory_type: str) -> bool:
        """Delete an event from Firebase"""
        if not self.is_connected:
            return False
            
        try:
            if territory_type == 'milestone':
                milestone_doc = self.db.collection('events').document('milestone_events')
                milestone_data = milestone_doc.get().to_dict() or {'milestones': []}
                milestone_data['milestones'] = [
                    e for e in milestone_data['milestones'] 
                    if e.get('id') != event_id
                ]
                milestone_doc.set(milestone_data)
            else:
                territory_doc = self.db.collection('events').document('territory_events')
                territory_data = territory_doc.get().to_dict() or {}
                if territory_type in territory_data:
                    territory_data[territory_type] = [
                        e for e in territory_data[territory_type] 
                        if e.get('id') != event_id
                    ]
                    territory_doc.set(territory_data)
            
            logger.info(f"Deleted event: {event_id}")
            return True
            
        except Exception as e:
            logger.error(f"Error deleting event: {e}")
            return False

class EventEditDialog(QDialog):
    """Dialog for editing event properties"""
    
    def __init__(self, event: Optional[Dict] = None, parent=None):
        super().__init__(parent)
        self.event = event or {}
        self.init_ui()
        
    def init_ui(self):
        self.setWindowTitle("Edit Event")
        self.setModal(True)
        self.resize(500, 600)
        
        layout = QVBoxLayout()
        
        # Form layout
        form_layout = QFormLayout()
        
        # Event ID
        self.id_edit = QLineEdit(self.event.get('id', ''))
        form_layout.addRow("Event ID:", self.id_edit)
        
        # Title
        self.title_edit = QLineEdit(self.event.get('title', ''))
        form_layout.addRow("Title:", self.title_edit)
        
        # Description
        self.description_edit = QTextEdit(self.event.get('description', ''))
        self.description_edit.setMaximumHeight(100)
        form_layout.addRow("Description:", self.description_edit)
        
        # Event Type
        self.type_combo = QComboBox()
        self.type_combo.addItems(['immigration', 'emigration', 'disaster', 'milestone'])
        current_type = self.event.get('type', 'immigration')
        index = self.type_combo.findText(current_type)
        if index >= 0:
            self.type_combo.setCurrentIndex(index)
        form_layout.addRow("Type:", self.type_combo)
        
        # Territory Type
        self.territory_combo = QComboBox()
        self.territory_combo.addItems([
            'rural', 'urban', 'border', 'coastal', 'caves', 'underground',
            'mountains', 'desert', 'arctic', 'orbital', 'space_station', 'milestone'
        ])
        current_territory = self.event.get('territoryType', 'rural')
        index = self.territory_combo.findText(current_territory)
        if index >= 0:
            self.territory_combo.setCurrentIndex(index)
        form_layout.addRow("Territory Type:", self.territory_combo)
        
        # Population Change
        self.population_spin = QDoubleSpinBox()
        self.population_spin.setRange(-100.0, 100.0)
        self.population_spin.setValue(self.event.get('populationChange', 0.0))
        form_layout.addRow("Population Change:", self.population_spin)
        
        # Probability
        self.probability_spin = QDoubleSpinBox()
        self.probability_spin.setRange(0.0, 1.0)
        self.probability_spin.setSingleStep(0.01)
        self.probability_spin.setValue(self.event.get('probability', 0.1))
        form_layout.addRow("Probability:", self.probability_spin)
        
        # Category
        self.category_combo = QComboBox()
        self.category_combo.addItems(['opportunity', 'disaster', 'conflict', 'epidemic', 'milestone'])
        current_category = self.event.get('category', 'opportunity')
        index = self.category_combo.findText(current_category)
        if index >= 0:
            self.category_combo.setCurrentIndex(index)
        form_layout.addRow("Category:", self.category_combo)
        
        # Threshold (for milestone events)
        self.threshold_spin = QSpinBox()
        self.threshold_spin.setRange(0, 10000)
        self.threshold_spin.setValue(self.event.get('threshold', 0))
        form_layout.addRow("Threshold:", self.threshold_spin)
        
        layout.addLayout(form_layout)
        
        # Buttons
        button_box = QDialogButtonBox(
            QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel
        )
        button_box.accepted.connect(self.accept)
        button_box.rejected.connect(self.reject)
        layout.addWidget(button_box)
        
        self.setLayout(layout)
    
    def get_event_data(self) -> Dict:
        """Get event data from form"""
        return {
            'id': self.id_edit.text(),
            'title': self.title_edit.text(),
            'description': self.description_edit.toPlainText(),
            'type': self.type_combo.currentText(),
            'territoryType': self.territory_combo.currentText(),
            'populationChange': self.population_spin.value(),
            'probability': self.probability_spin.value(),
            'category': self.category_combo.currentText(),
            'threshold': self.threshold_spin.value() if self.threshold_spin.value() > 0 else None
        }

class EventManagementWidget(QWidget):
    """Main widget for managing events"""
    
    def __init__(self):
        super().__init__()
        self.firebase_manager = FirebaseManager()
        self.events = []
        self.init_ui()
        
    def init_ui(self):
        layout = QVBoxLayout()
        
        # Connection section
        connection_group = QGroupBox("Firebase Connection")
        connection_layout = QHBoxLayout()
        
        self.credentials_path_edit = QLineEdit()
        self.credentials_path_edit.setPlaceholderText("Path to Firebase credentials JSON file")
        connection_layout.addWidget(QLabel("Credentials:"))
        connection_layout.addWidget(self.credentials_path_edit)
        
        self.connect_button = QPushButton("Connect")
        self.connect_button.clicked.connect(self.connect_to_firebase)
        connection_layout.addWidget(self.connect_button)
        
        self.connection_status = QLabel("Not connected")
        connection_layout.addWidget(self.connection_status)
        
        connection_group.setLayout(connection_layout)
        layout.addWidget(connection_group)
        
        # Events table
        self.events_table = QTableWidget()
        self.events_table.setColumnCount(8)
        self.events_table.setHorizontalHeaderLabels([
            "ID", "Title", "Type", "Territory", "Population", "Probability", "Category", "Threshold"
        ])
        self.events_table.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        layout.addWidget(self.events_table)
        
        # Buttons
        button_layout = QHBoxLayout()
        
        self.add_button = QPushButton("Add Event")
        self.add_button.clicked.connect(self.add_event)
        button_layout.addWidget(self.add_button)
        
        self.edit_button = QPushButton("Edit Event")
        self.edit_button.clicked.connect(self.edit_event)
        button_layout.addWidget(self.edit_button)
        
        self.delete_button = QPushButton("Delete Event")
        self.delete_button.clicked.connect(self.delete_event)
        button_layout.addWidget(self.delete_button)
        
        self.refresh_button = QPushButton("Refresh")
        self.refresh_button.clicked.connect(self.refresh_events)
        button_layout.addWidget(self.refresh_button)
        
        layout.addLayout(button_layout)
        
        self.setLayout(layout)
        
        # Disable buttons until connected
        self.add_button.setEnabled(False)
        self.edit_button.setEnabled(False)
        self.delete_button.setEnabled(False)
        self.refresh_button.setEnabled(False)
    
    def connect_to_firebase(self):
        """Connect to Firebase using provided credentials"""
        credentials_path = self.credentials_path_edit.text()
        if not credentials_path:
            QMessageBox.warning(self, "Warning", "Please provide Firebase credentials path")
            return
        
        if not os.path.exists(credentials_path):
            QMessageBox.warning(self, "Warning", "Credentials file not found")
            return
        
        if self.firebase_manager.connect(credentials_path):
            self.connection_status.setText("Connected")
            self.connection_status.setStyleSheet("color: green")
            self.connect_button.setEnabled(False)
            
            # Enable buttons
            self.add_button.setEnabled(True)
            self.edit_button.setEnabled(True)
            self.delete_button.setEnabled(True)
            self.refresh_button.setEnabled(True)
            
            # Load events
            self.refresh_events()
        else:
            self.connection_status.setText("Connection failed")
            self.connection_status.setStyleSheet("color: red")
    
    def refresh_events(self):
        """Refresh events from Firebase"""
        if not self.firebase_manager.is_connected:
            return
        
        self.events = self.firebase_manager.get_all_events()
        self.populate_table()
    
    def populate_table(self):
        """Populate the events table"""
        self.events_table.setRowCount(len(self.events))
        
        for row, event in enumerate(self.events):
            self.events_table.setItem(row, 0, QTableWidgetItem(event.get('id', '')))
            self.events_table.setItem(row, 1, QTableWidgetItem(event.get('title', '')))
            self.events_table.setItem(row, 2, QTableWidgetItem(event.get('type', '')))
            self.events_table.setItem(row, 3, QTableWidgetItem(event.get('territoryType', '')))
            self.events_table.setItem(row, 4, QTableWidgetItem(str(event.get('populationChange', 0))))
            self.events_table.setItem(row, 5, QTableWidgetItem(str(event.get('probability', 0))))
            self.events_table.setItem(row, 6, QTableWidgetItem(event.get('category', '')))
            self.events_table.setItem(row, 7, QTableWidgetItem(str(event.get('threshold', ''))))
    
    def add_event(self):
        """Add a new event"""
        dialog = EventEditDialog(parent=self)
        if dialog.exec() == QDialog.DialogCode.Accepted:
            event_data = dialog.get_event_data()
            territory_type = event_data.pop('territoryType')
            
            if self.firebase_manager.add_event(event_data, territory_type):
                QMessageBox.information(self, "Success", "Event added successfully")
                self.refresh_events()
            else:
                QMessageBox.warning(self, "Error", "Failed to add event")
    
    def edit_event(self):
        """Edit selected event"""
        current_row = self.events_table.currentRow()
        if current_row < 0:
            QMessageBox.warning(self, "Warning", "Please select an event to edit")
            return
        
        event = self.events[current_row]
        dialog = EventEditDialog(event, parent=self)
        if dialog.exec() == QDialog.DialogCode.Accepted:
            event_data = dialog.get_event_data()
            territory_type = event_data.pop('territoryType')
            
            if self.firebase_manager.update_event(event_data, territory_type):
                QMessageBox.information(self, "Success", "Event updated successfully")
                self.refresh_events()
            else:
                QMessageBox.warning(self, "Error", "Failed to update event")
    
    def delete_event(self):
        """Delete selected event"""
        current_row = self.events_table.currentRow()
        if current_row < 0:
            QMessageBox.warning(self, "Warning", "Please select an event to delete")
            return
        
        event = self.events[current_row]
        event_id = event.get('id')
        territory_type = event.get('territoryType')
        
        reply = QMessageBox.question(
            self, "Confirm Delete", 
            f"Are you sure you want to delete event '{event_id}'?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        )
        
        if reply == QMessageBox.StandardButton.Yes:
            if self.firebase_manager.delete_event(event_id, territory_type):
                QMessageBox.information(self, "Success", "Event deleted successfully")
                self.refresh_events()
            else:
                QMessageBox.warning(self, "Error", "Failed to delete event")

class MainWindow(QMainWindow):
    """Main application window"""
    
    def __init__(self):
        super().__init__()
        self.init_ui()
        
    def init_ui(self):
        self.setWindowTitle("The Immigrants - Event Management Backend")
        self.setGeometry(100, 100, 1200, 800)
        
        # Central widget
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        # Layout
        layout = QVBoxLayout()
        
        # Title
        title_label = QLabel("The Immigrants - Event Management Backend")
        title_label.setFont(QFont("Arial", 16, QFont.Weight.Bold))
        title_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(title_label)
        
        # Tab widget
        tabs = QTabWidget()
        
        # Events tab
        events_tab = EventManagementWidget()
        tabs.addTab(events_tab, "Events")
        
        layout.addWidget(tabs)
        
        central_widget.setLayout(layout)
        
        # Status bar
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("Ready")
        
        # Menu bar
        self.create_menu_bar()
    
    def create_menu_bar(self):
        """Create menu bar"""
        menubar = self.menuBar()
        
        # File menu
        file_menu = menubar.addMenu("File")
        
        exit_action = QAction("Exit", self)
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)
        
        # Help menu
        help_menu = menubar.addMenu("Help")
        
        about_action = QAction("About", self)
        about_action.triggered.connect(self.show_about)
        help_menu.addAction(about_action)
    
    def show_about(self):
        """Show about dialog"""
        QMessageBox.about(
            self,
            "About",
            "The Immigrants - Event Management Backend\n\n"
            "A Python Qt application for managing game events in Firebase.\n\n"
            "Version: 1.0.0"
        )

def main():
    """Main entry point"""
    app = QApplication(sys.argv)
    app.setApplicationName("The Immigrants Event Manager")
    app.setOrganizationName("The Immigrants Game")
    
    # Set application style
    app.setStyle('Fusion')
    
    # Create main window
    window = MainWindow()
    window.show()
    
    # Run application
    sys.exit(app.exec())

if __name__ == "__main__":
    main()